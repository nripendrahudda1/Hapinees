class Endpoints{
  Endpoints._();

  static const String baseUrl = 'https://masjidappword.herokuapp.com';
  static const String signupUrl = '/api/singup/';
  static const Duration connectionTimeOut = Duration(milliseconds: 50000);
  static const Duration receiveTimeOut = Duration(milliseconds: 80000);
}