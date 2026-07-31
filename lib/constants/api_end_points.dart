// class ApiEndpoints {
//   // static const String baseUrl = "https://qjh.mazedigital.us/";
//   // static const String baseUrl = "https://qjr-staging-backend.mazedigital.us/";
//   static const String baseUrl = "https://qjr-staging-backend.mazedigital.us/";
//   // static const String baseUrl = "https://b6z006k3-1020.inc1.devtunnels.ms/";
//   static const String signUp = "${baseUrl}auth/signup";
//   static const String verifyEmail = "${baseUrl}auth/verify-email";
//   static const String verifyOtp = "${baseUrl}auth/verify-otp";
//   static const String forgetPassword = "${baseUrl}auth/forget-password";
//   static const String login = "${baseUrl}auth/signin";
//   static const String logout = "${baseUrl}auth/logout";
//   static const String getUser = "${baseUrl}auth/get-user";
//   static const String changePassword = "${baseUrl}auth/change-password";
//   static const String feedBack = "${baseUrl}auth/submitFeedback";
//   static const String report = "${baseUrl}auth/submitReport";
//   static const String deletAccount = "${baseUrl}auth/delete-account";
//   static const String getAllPackages = "${baseUrl}payment/packages";
//   static const String createPaymentMethod = "${baseUrl}payment/create-payment";
//   static const String validateReciept = "${baseUrl}api/apple/verify";
//   static const String checkSubscription =
//       "${baseUrl}api/apple/check-subscription";
//   static const String editPaymentPlan = "${baseUrl}auth/update-package";
//   static const String updatePaymentPlan = "${baseUrl}api/apple/validate";
//   static const String autoRenewUpdate = "${baseUrl}auth/update-autoRenew";
//   static const String getAllQuoteThemes = "${baseUrl}theme/get-allThemes";
//   static const String saveTheme = "${baseUrl}themes/select-theme";
//   static const String getAllSubThemeNotifications = "${baseUrl}notification";
//   static String getSubThemeNotificationDetail(id) =>
//       "${baseUrl}theme/subTheme/$id";
//   static const String preference = "${baseUrl}preference";
//   static const String saveThemeAndTimePrefrence =
//       "${baseUrl}themes/select-theme-and-preference";
//   static String getPreference(String themeId) => "${baseUrl}preference";
//   static const String getFavoriteSubThemes =
//       "${baseUrl}favourite/get-favourite";
//   static const String markAsFavoritesOrUnFavoriteSubThemes =
//       "${baseUrl}favourite/markAsFavourite";
//   static const String requestTheme = "${baseUrl}theme/request-theme";
//   static const String presignUpload = "${baseUrl}upload/presign";
//   // static const String getAllBubble = "${baseUrl}bubble/get-all-bubble";
//   // static const String getbubbleOptions =
//   //     "${baseUrl}option/get-all-bubble-option-by-bubble-id/";
//   //       static const String chatCompletionOpenAIUrl =
//   //     "https://api.openai.com/v1/chat/completions";
// }

// class AdminApiUrls {
//   static const String baseUrl = "https://qjh.mazedigital.us";
//   static const String getAllThemes = "$baseUrl/theme/get-allThemes";
//   static const String addTheme = "$baseUrl/themes/add-theme";
//   static const String addSubTheme = "$baseUrl/theme/add-sub-theme";
//   static String updateTheme(id) => "$baseUrl/themes/update-theme/$id";
//   static String deleteTheme(id) => "$baseUrl/theme/delete-theme/$id";
//   static String updateSubTheme(id) => "$baseUrl/theme/update-sub-theme/$id";
//   static String getAllSubThemes(id) =>
//       "$baseUrl/theme/get-themeWithSubthemeBy-id/$id";
//   static String deleteSubTheme(id) => "$baseUrl/theme/delete-sub-theme/$id";
//   static String getSubthemesById(id) =>
//       "$baseUrl/theme/get-themeWithSubthemeBy-id/$id";
// }

enum _Env { production, staging, tunnel }

const _active = _Env.staging; // ← change only this line to switch environment

const _baseUrl = _active == _Env.production
    ? "https://qjh.mazedigital.us/"
    : _active == _Env.staging
        ? "https://qjr-staging-backend.mazedigital.us/"
        : _active == _Env.tunnel
            ? "https://0znq2n4t-8080.inc1.devtunnels.ms/"
            : "https://qjh.mazedigital.us/";

class ApiEndpoints {
  static const String baseUrl = _baseUrl;
  static const String signUp = "${baseUrl}auth/signup";
  static const String verifyEmail = "${baseUrl}auth/verify-email";
  static const String verifyOtp = "${baseUrl}auth/verify-otp";
  static const String forgetPassword = "${baseUrl}auth/forget-password";
  static const String login = "${baseUrl}auth/signin";
  static const String logout = "${baseUrl}auth/logout";
  static const String getUser = "${baseUrl}auth/get-user";
  static const String changePassword = "${baseUrl}auth/change-password";
  static const String feedBack = "${baseUrl}auth/submitFeedback";
  static const String report = "${baseUrl}auth/submitReport";
  static const String deletAccount = "${baseUrl}auth/delete-account";
  static const String getAllPackages = "${baseUrl}payment/packages";
  static const String createPaymentMethod = "${baseUrl}payment/create-payment";
  static const String validateReciept = "${baseUrl}api/apple/verify";
  static const String checkSubscription =
      "${baseUrl}api/apple/check-subscription";
  static const String editPaymentPlan = "${baseUrl}auth/update-package";
  static const String updatePaymentPlan = "${baseUrl}api/apple/validate";
  static const String autoRenewUpdate = "${baseUrl}auth/update-autoRenew";
  static const String getAllQuoteThemes = "${baseUrl}theme/get-allThemes";
  static const String saveTheme = "${baseUrl}themes/select-theme";
  static const String getAllSubThemeNotifications = "${baseUrl}notification";
  static String getSubThemeNotificationDetail(id) =>
      "${baseUrl}theme/subTheme/$id";
  static const String preference = "${baseUrl}preference";
  static const String saveThemeAndTimePrefrence =
      "${baseUrl}themes/select-theme-and-preference";
  static String getPreference(String themeId) => "${baseUrl}preference";
  static const String getFavoriteSubThemes =
      "${baseUrl}favourite/get-favourite";
  static const String markAsFavoritesOrUnFavoriteSubThemes =
      "${baseUrl}favourite/markAsFavourite";
  static const String requestTheme = "${baseUrl}theme/request-theme";
  static const String presignUpload = "${baseUrl}upload/presign";
  // static const String getAllBubble = "${baseUrl}bubble/get-all-bubble";
  // static const String getbubbleOptions =
  //     "${baseUrl}option/get-all-bubble-option-by-bubble-id/";
  //       static const String chatCompletionOpenAIUrl =
  //     "https://api.openai.com/v1/chat/completions";
}

class AdminApiUrls {
  static const String baseUrl = "https://qjh.mazedigital.us";
  static const String getAllThemes = "$baseUrl/theme/get-allThemes";
  static const String addTheme = "$baseUrl/themes/add-theme";
  static const String addSubTheme = "$baseUrl/theme/add-sub-theme";
  static String updateTheme(id) => "$baseUrl/themes/update-theme/$id";
  static String deleteTheme(id) => "$baseUrl/theme/delete-theme/$id";
  static String updateSubTheme(id) => "$baseUrl/theme/update-sub-theme/$id";
  static String getAllSubThemes(id) =>
      "$baseUrl/theme/get-themeWithSubthemeBy-id/$id";
  static String deleteSubTheme(id) => "$baseUrl/theme/delete-sub-theme/$id";
  static String getSubthemesById(id) =>
      "$baseUrl/theme/get-themeWithSubthemeBy-id/$id";
}
