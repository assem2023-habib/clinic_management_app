# ADB Daemon — Permission Denied (`adb.log`)

## وصف المشكلة

عند تشغيل `flutter run` أو أي أمر `adb`، يتعذر تشغيل خادم ADB بسبب خطأ صلاحية في ملف السجل:

```
* daemon not running; starting now at tcp:5037
F adb: main.cpp:55 cannot open C:\Users\RYZEN\AppData\Local\Temp\adb.log: Permission denied
could not read ok from ADB Server
* failed to start daemon
adb.exe: failed to check server version: cannot connect to daemon
```

الجهاز يظهر في `flutter devices` بعد عدة محاولات لكن `flutter run` يفشل.

---

## السبب الجذري

ملف `%TEMP%\adb.log` يحتوي على **NULL SID deny ACE** في صلاحياته:

```
NULL SID:(DENY)(Rc,S,DC)
```

هذا الـ ACE يمنع:
- **Rc** — Read control
- **S** — Synchronize
- **DC** — Delete child

بالتالي أي عملية قراءة/كتابة/حذف على الملف ترفض حتى لو كان المستخدم هو المالك أو Administrator.

### الأسباب المحتملة لظهور NULL SID

| السبب | الشرح |
|---|---|
| تشغيل ADB سابقًا بخدمة SYSTEM | إذا تم تشغيل ADB عبر خدمة Windows أو Scheduled Task بحساب SYSTEM، ينشئ الملف بصلاحيات SYSTEM ثم يُضاف NULL SID deny عند محاولة المستخدم العادي الوصول إليه |
| برنامج مكافحة فيروسات أو أمان | بعض برامج الأمان (مثل BitDefender, Kaspersky, Windows Defender) قد تفرض NULL SID deny كإجراء وقائي على ملفات logs |
| انقطاع غير طبيعي لـ ADB | إذا انتهت عملية ADB بشكل غير متوقع (crash, kill -9)، قد يترك الملف في حالة صلاحية غير مستقرة |
| تحديث Windows أو ADB | بعد تحديث Windows أو تحديث ADB/SDK Tools، قد يتغير معالج إنشاء الملف ويسبب تضاربًا في الصلاحيات |
| استخدام أداة تنظيف (CCleaner, etc.) | أدوات تنظيف الـ Temp قد تحذف الملف ثم يُعاد إنشاؤه بصلاحيات مختلفة عند تشغيل ADB التالي |

---

## خطوات الحل

### 1️⃣ قتل عمليات ADB الجارية

```
taskkill /f /im adb.exe
```

تأكد من عدم وجود أي عملية ADB في Task Manager.

### 2️⃣ إعادة تسمية ملف adb.log (وليس حذفه)

```
Rename-Item -Path "$env:TEMP\adb.log" -NewName "adb.log.old"
```

> **لماذا إعادة تسمية وليس حذف؟**
> الملف مقفول بـ NULL SID deny، وأمر `Remove-Item` أو `del` سيفشل. لكن `Rename-Item` يعمل أحيانًا لأن Windows يعتبر إعادة التسمية عملية "metadata" وليست "delete".

إذا فشلت إعادة التسمية أيضًا، جرب:

```
takeown /f "%TEMP%\adb.log"
icacls "%TEMP%\adb.log" /grant "%USERNAME%:(F)"
```

وإذا لم تنجح هذه، فشغل PowerShell **كمسؤول (Administrator)** وكرر الخطوات.

### 3️⃣ تشغيل ADB

```
adb devices
```

أو:

```
flutter run
```

الآن ADB سينشئ ملف `adb.log` جديدًا بصلاحيات سليمة ويعمل بشكل طبيعي.

---

## منع تكرار المشكلة

| الإجراء | الوصف |
|---|---|
| تعطيل الفحص في الوقت الحقيقي لـ `%TEMP%` | أضف استثناء لمجلد `%TEMP%` في برنامج الأمان لديك |
| تحديث ADB | استخدم `flutter upgrade` أو حمل أحدث `platform-tools` من Google |
| تشغيل ADB مرة واحدة بعد كل reboot | شغّل `adb devices` مرة بعد إقلاع الجهاز لتجنب بقاء ملفات تالفة |
| Script تلقائي | أضف السكربت التالي ليشتغل مع بدء التشغيل أو عند flutter run |

```powershell
# fix-adb.ps1
taskkill /f /im adb.exe 2>$null
if (Test-Path "$env:TEMP\adb.log") {
    Rename-Item -Path "$env:TEMP\adb.log" -NewName "adb.log.$((Get-Date).ToString('yyyyMMddHHmmss'))" -Force
}
```

---

## ملخص

```
المشكلة:  ADB daemon لا يبدأ — Permission denied على %TEMP%\adb.log
السبب:    NULL SID deny ACE في صلاحيات الملف
الحل:     إعادة تسمية الملف (Rename-Item) ثم تشغيل ADB من جديد
الجهاز:   RMX3263 (Android 11, ARM64)
تاريخ أول ظهور: 13 يونيو 2026
```
