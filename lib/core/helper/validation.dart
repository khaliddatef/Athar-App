class AppValidator {
  /// validate email
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(value.trim())) {
      return 'من فضلك أدخل بريد إلكتروني صحيح';
    }
    return null;
  }

  /// validate password
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الرقم السري مطلوب';
    }
    if (value.length < 6) {
      return 'الرقم السري يجب أن يكون 6 أحرف على الأقل';
    }
    return null;
  }

  /// validate confirm password
  static String? validateConfirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال كلمة المرور مرة أخرى';
    }
    if (value != original) {
      return 'كلمة المرور غير متطابقة';
    }
    return null;
  }

  /// validate national ID
  static String? validateNationalId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الرجاء إدخال الرقم القومي';
    }
    final nationalIdRegex = RegExp(r'^[2-3][0-9]{13}$');
    if (!nationalIdRegex.hasMatch(value.trim())) {
      return 'الرجاء إدخال رقم قومي صالح مكون من 14 رقم';
    }
    return null;
  }

  /// validate phone
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الرجاء إدخال رقم الهاتف';
    }
    final phoneRegex = RegExp(r'^[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'الرجاء إدخال رقم هاتف صالح';
    }
    return null;
  }

  /// validate name
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الاسم مطلوب';
    }
    if (value.trim().length < 3) {
      return 'الاسم يجب أن يكون 3 أحرف على الأقل';
    }
    return null;
  }

  /// validate birthdate
  static String? validateBirthdate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'تاريخ الميلاد مطلوب';
    }
    final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateRegex.hasMatch(value.trim())) {
      return 'الصيغة يجب أن تكون YYYY-MM-DD';
    }
    try {
      final date = DateTime.parse(value.trim());
      final now = DateTime.now();
      int age = now.year - date.year;

      if (
        now.month < date.month ||
        (now.month == date.month && now.day < date.day)
      ) {
        age -= 1;
      }

      if (age < 10 || age > 100) {
        return 'العمر يجب أن يكون بين 10 و 100 سنة';
      }
    } catch (e) {
      return 'تاريخ غير صحيح';
    }
    return null;
  }

  /// validate Age
  static String? validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'العمر مطلوب';
    }
    if (int.tryParse(value.trim()) == null) {
      return "من فضلك أدخل عمر صحيح";
    }
    return null;
  }

  /// validate City
  static String? validateCity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'المحافظة مطلوبة';
    }
    return null;
  }
}
