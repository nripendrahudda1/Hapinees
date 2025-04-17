enum VisibilityEnum{
  Public('1'),
  Private('2'),
  Guests('3');


  const VisibilityEnum(this.type);
  final String type;
}

extension ConvertVisibilityEnum on String{
  VisibilityEnum toVisibilityEnum(){
    switch(this){
      case '1':
        return VisibilityEnum.Public;
      case '2':
        return VisibilityEnum.Private;
      case '3':
        return VisibilityEnum.Guests;
      default:
        return VisibilityEnum.Guests;
    }
  }
}