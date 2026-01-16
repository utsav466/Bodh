// class ApiEndpoints {
//   ApiEndpoints._();

//   //Info: Base URL
//   static const String baseUrl =
//       "http://10.0.2.2:3000/api/v1"; // info: for android
//   // static const String baseUrl =
//   //     "http://192.168.100.8:3000/api/v1"; // info: for physical device use computers IP

//   // Note: For physical device use computer IP: "http:/102.168.x.x:5000/api/v1"

//   static const Duration connectionTimeout = Duration(seconds: 30);
//   static const Duration receiveTimeout = Duration(seconds: 30);

//   // Hack: ========== Batch Endpoints ===========
//   static const String batches = "/batches";
//   static String batchById(String id) => '/batches/$id';

//   // Hack: ========== Categories Endpoints ===========
//   static const String categories = "/categories";
//   static String categoriesById(String id) => '/categories/$id';

//   // Hack: ========== Student Endpoints ===========
//   static const String students = "/students";
//   static const String studentLogin = "/students/login";
//   static const String studentRegister = "/students/register";
//   static String studentById(String id) => '/students/$id';
//   static String studentPhoto(String id) => "/students/$id/photo";

//   // Hack: ========== Item Endpoints ===========
//   static const String items = "/items";
//   static String itemsById(String id) => '/items/$id';
//   static String itemsClaim(String id) => '/items/$id/claim';

//   // Hack: ========== Comment Endpoints ===========
//   static const String comments = "/comments";
//   static String commentById(String id) => '/comments/$id';
//   static String commentsByItems(String itemId) => "comments/item/$itemId";
//   static String commentLike(String id) => '/items/$id/like';
// }



// class ApiEndpoints {
//   ApiEndpoints._();

//   // Base URL
//   static const String baseUrl =
//       "http://10.0.2.2:3000/api/v1"; // For Android emulator
//   // static const String baseUrl =
//   //     "http://192.168.x.x:3000/api/v1"; // For physical device (replace with your computer IP)

//   static const Duration connectionTimeout = Duration(seconds: 30);
//   static const Duration receiveTimeout = Duration(seconds: 30);

//   // Batch Endpoints
//   static const String batches = "/batches";
//   static String batchById(String id) => "/batches/$id";

//   // Categories Endpoints
//   static const String categories = "/categories";
//   static String categoriesById(String id) => "/categories/$id";

//   // Student Endpoints
//   static const String students = "/students";
//   static const String studentLogin = "/students/login";
//   static const String studentRegister = "/students/register";
//   static String studentById(String id) => "/students/$id";
//   static String studentPhoto(String id) => "/students/$id/photo";

//   // Item Endpoints
//   static const String items = "/items";
//   static String itemsById(String id) => "/items/$id";
//   static String itemsClaim(String id) => "/items/$id/claim";

//   // Comment Endpoints
//   static const String comments = "/comments";
//   static String commentById(String id) => "/comments/$id";
//   static String commentsByItems(String itemId) => "/comments/item/$itemId";
//   static String commentLike(String id) => "/comments/$id/like";
// }

class ApiEndpoints {
  ApiEndpoints._();

  // Base URL
  static const String baseUrl =
      "http://10.0.2.2:5050"; // ✅ Android Emulator (backend port 5050)

  // static const String baseUrl =
  //     "http://192.168.x.x:5050"; // ✅ Physical device (replace with your computer IP)

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ========== Auth Endpoints ==========
  static const String register = "/api/auth/register";
  static const String login = "/api/auth/login";

  // If you later add more user endpoints:
  static const String users = "/api/users";
  static String userById(String id) => "/api/users/$id";
}
