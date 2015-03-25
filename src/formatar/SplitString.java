package formatar;


public class SplitString {
	public String entrada;
	private String separator;
	public String[] retornaString(){
		Separator();
		String[] retorno = entrada.split(separator);
		return retorno;
	}
	private String Separator(){
	  String specialCharacters = "%!@#$#^&*()?/>.<:;\\|}]{[_~`+=-" +"\"";
	  char[] specialCharactersArray = specialCharacters.toCharArray();
	  char[] a = entrada.toCharArray();
	  for(int i = 0; i<a.length; i++){
		  for(int y=0; y < specialCharactersArray.length; i++){
			  if(a[i] == specialCharactersArray[y]){
				  separator = String.valueOf(specialCharactersArray[y]);   
			  }
		  }
	  }
	  return separator;
	}
}
