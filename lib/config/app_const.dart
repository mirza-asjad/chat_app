// ignore_for_file: constant_identifier_names

class CollectionKey {
  static const USERS = 'users';
  static const CALLS = 'calls';
  static const TOPIC_SELECTION = 'topic_selection';
  static const CHAT_HISTORY = 'chat_history';
  static const CHATS = 'chats';
  static const MESSAGES = 'messages';
  static const SUGGESTIONS = 'suggestions';
}

class UserKey {
  static const USER_NAME = 'userName';
  static const USER_EMAIL = 'userEmail';
  static const PHONE_NUMBER = 'userPhoneNumber';
  static const PASSWORD = 'userPassword';
  static const CREATED_AT = 'userCreatedAt';
  static const FCMTOKEN = 'userFcmToken';
  static const SEARCH_PARAMS_FOR_NAME = 'userSearchParamsForName';
  static const SEARCH_PARAMS_FOR_NUMBER = 'userSearchParamsForNumber';
  static const UID = 'userUid';
  static const USER_SIGNUP_METHOD = 'userSignupMethod';
  static const USER_SIGNUP_METHOD_IS_EMAIL = 'Email';
  static const USER_SIGNUP_METHOD_IS_GOOLE = 'Google';
  static const IS_DARK_MODE = 'isDarkMode';
  static const CATEGORY = 'userSelectedCategory';
  static const SUB_CATEGORY = 'userSelectedSubCategory';
  static const IS_USER_CHOOSED_CATEGORY = 'isUserChoosedCategory';
  static const CURRENT_CHAT_ID = 'currentChatId';
}

class TopicKey {
  static const CATEGORY = 'userSelectedCategory';
  static const SUB_CATEGORY = 'userSelectedSubCategory';
  static const TOPIC_OPTIONS = 'topicOptions';
  static const DOCUMENT_ID = 'JFCUl6hQDku5LeRd6bOW';
}

class UserSession {
  static const IS_USER_LOGGED_IN = 'userSession';
}

class ApiUrl {
  static const API_URL_FOR_POST =
      'https://us-central1-lumosia-411407.cloudfunctions.net';
}

class AppURLS {
  static const PRIVACY_POLICY =
      'https://www.termsfeed.com/live/953577c2-489a-44eb-8304-ff42c3ddb0eb';
  static const TERMS_AND_CONDITIONS =
      'https://www.freeprivacypolicy.com/live/629db68d-51ad-413e-8f8e-262f2c5c80f1';
}

class ApiResponse {
  static const RESPONSE = 'response';
  static const HISTORICAL_VECTOR = 'historical-vector';
  static const CONTEXT = 'context';
}

class ApiRequest {
  static const MESSAGE = 'message';
  static const HISTORICAL_VECTOR = 'historical-vector';
  static const CONTEXT = 'context';
  static const CODE = 'code';
  static const STATE = 'state';
}

class History {
  static const MESSAGE = 'message';
  static const REQUEST_HISTORICAL_VECTOR = 'requestHistoricalVector';
  static const RESPONSE_HISTORICAL_VECTOR = 'responseHistoricalVector';
  static const REQUEST_CONTEXT = 'requestContext';
  static const RESPONSE_CONTEXT = 'responseContext';
  static const CODE = 'code';
  static const STATE = 'state';
  static const RESPONSE = 'response';
  static const SENDER = 'sender';
  static const BOT = 'bot';
  static const UPDATED_AT = 'updatedAt';
  static const CREATED_AT = 'createdAt';
  static const IS_ACTIVE = 'isActive';
  static const TIME_OF_MESSAGE = 'timeOfMessage';
}

class Messages {
  static const TEXT = 'text';
  static const MESSAGE = 'message';
  static const SENDER = 'sender';
  static const BOT = 'bot';
  static const USER = 'user';
  static const ERROR = 'Failed to get a response from the server.';
}

class Suggestions {
  static const TITLE = 'title';
  static const DESCRIPTION = 'description';
  static const DOCUMENT_ID = 'fN2ABjVDpRsWb5upLAUL';
  static const SUGGESTIONS = 'suggestions';
}

class SelectedState {
  static const TEXAS = 'texas';
}
