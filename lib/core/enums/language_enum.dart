enum LanguageEnum{
  EN('EN');


  const LanguageEnum(this.type);
  final String type;
}

extension ConvertLanguageEnum on String{
  LanguageEnum toLanguageEnum(){
    switch(this){
      case 'EN':
        return LanguageEnum.EN;
      default:
        return LanguageEnum.EN;
    }
  }
}