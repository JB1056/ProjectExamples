import SwiftUI

struct EmailChallenge: View {
    
    let placeholder: String
    let iconName: String
    let text: Binding<String>
    let keyboardType: UIKeyboardType
    let isValid: (String) -> Bool
    
    init(placeholder: String,
         iconName: String,
         text: Binding<String>,
         keyboardType: UIKeyboardType = UIKeyboardType.default,
         isValid: @escaping (String)-> Bool = { _ in true}) {
        
        self.placeholder = placeholder
        self.iconName = iconName
        self.text = text
        self.keyboardType = keyboardType
        self.isValid = isValid
    }
    
    var showsError: Bool {
        if text.wrappedValue.isEmpty {
            return false
        } else {
            return !isValid(text.wrappedValue)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                CustomTextField(
                    placeholder: Text(placeholder).foregroundColor(.gray),
                    text: text
                )
                    .keyboardType(keyboardType)
                    .autocapitalization(.none)
                Image(systemName: iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                    .foregroundColor(.gray)
                    .foregroundColor(showsError ? .red : Color(red: 189 / 255, green: 204 / 255, blue: 215 / 255))
            }
            Rectangle()
                .frame(height: 2)
                .foregroundColor(showsError ? .red : Color(red: 189 / 255, green: 204 / 255, blue: 215 / 255))
        }
    }
}


// FIGURE OUT WHAT THIS SHOULD BE
//func psuedoMethod() -> Method {
//    return Method
//}



struct SearchChallenge: View {
    
    let placeholder: String
    let iconName: String
    let inversed: Bool
    let text: Binding<String>
    let keyboardType: UIKeyboardType
//    let actionMethod: Method
        
    init(placeholder: String,
         iconName: String,
         text: Binding<String>,
         keyboardType: UIKeyboardType = UIKeyboardType.default,
         inversed: Bool
         /*actionMethod: Method*/) {
        
        self.placeholder = placeholder
        self.iconName = iconName
        self.inversed = inversed
        self.text = text
        self.keyboardType = keyboardType
//        self.actionMethod = actionMethod
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                CustomTextField(
                    placeholder: Text(placeholder).foregroundColor(inversed ? .white : .gray),
                    text: text
                )
                    .keyboardType(keyboardType)
                    .autocapitalization(.none)
//                    Button(action: { actionMethod } ) {
                        Image(systemName: iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 18, height: 18)
                        .foregroundColor((inversed ? .white : .gray))
//                    }
            }
            Rectangle().frame(height: 2).foregroundColor((inversed ? .white : .gray))
        }
    }
}





struct Email_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmailChallenge(
                placeholder: "test@email.com",
                iconName: "envelope.fill",
                text: .constant(""))
                .padding()
                .previewLayout(.fixed(width: 400, height: 100))
            
            EmailChallenge(
                placeholder: "test@email.com",
                iconName: "envelope.fill",
                text: .constant("success@email.com"))
                .padding()
                .previewLayout(.fixed(width: 400, height: 100))
            
            EmailChallenge(
                placeholder: "test@email.com",
                iconName: "envelope.fill",
                text: .constant("failedemail.com"),
                isValid: { _ in false })
                .padding()
                .previewLayout(.fixed(width: 400, height: 100))
        }
    }
}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchChallenge(
                placeholder: "Search",
                iconName: "magnifyingglass",
                text: .constant(""),
                inversed: false)
//                actionMethod: psuedoMethod())
                .padding()
                .previewLayout(.fixed(width: 400, height: 50))
                
            
            SearchChallenge(
                placeholder: "Search",
                iconName: "magnifyingglass",
                text: .constant(""),
                inversed: true)
//                actionMethod: psuedoMethod())
                .padding()
                .previewLayout(.fixed(width: 400, height: 50))
                .background(Color.gray)
            
            SearchChallenge(
                placeholder: "Search",
                iconName: "magnifyingglass",
                text: .constant("Completed Search"),
                inversed: true)
//                actionMethod: psuedoMethod())
                .padding()
                .previewLayout(.fixed(width: 400, height: 50))
            
            SearchChallenge(
                placeholder: "Search",
                iconName: "magnifyingglass",
                text: .constant("Completed Search"),
                inversed: true)
//                actionMethod: psuedoMethod())
                .padding()
                .previewLayout(.fixed(width: 400, height: 50))
                .background(Color.gray)
        }
    }
}
