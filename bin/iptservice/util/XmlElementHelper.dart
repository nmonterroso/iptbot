part of iptservice;

class XmlElementHelper {
  IptData extractData(XmlElement e) {
    IptData data = new IptData();
    XmlElement child;
    XmlText text;
    
    for (int i = 0; i < e.children.length; ++i) {
      child = e.children[i];
      
      if (child.children.length == 1 && child.children[0] is XmlText) {
        text = child.children[0];
        
        switch (child.name) {
          case 'title':
            data._title = text.text;
            break;
          case 'link':
            data._link = text.text;
            break;
          case 'pubDate':
            data._date = text.text;
            break;
          case 'description':
            data.size = text.text;
            break;
          default:
            continue;
        }
      }
    }
    
    return data;
  }
}