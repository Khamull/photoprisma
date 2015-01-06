package cadastro;

public class Usuario {
	
	public int usuarioID;
	public Funcionario funcionario = new Funcionario();
	public String nome;
	public String telefone;
	public String email;
	public String login;
	public String senha;
	public String nivel;
	public String msgErro = "";
	public Empresa empresa = new Empresa();
	
	//Metodo para verificar login, senha e Entrar no Sistema
	public String logar(){
		return "SELECT * FROM usuario WHERE usuarioLogin = '"+login+"' AND usuarioSenha = '"+senha+"' AND usuarioAtivo = 'S'";
	}
	
	//Metodo para verifica login, senha e unidade antes de Entrar no Sistema
	public String logarUnidade() {
		String logaSis = "SELECT * FROM usuario WHERE usuarioLogin = '"+login+"' AND ";
		logaSis += "usuarioSenha = '"+senha+"' AND empresaID = '"+empresa.empresaID+"' AND usuarioAtivo = 'S'";
		
		return logaSis;
	}
	
	
	
	
	
	
	
	//Metodo para verificar login, senha e Entrar no Sistema (EXCLUSIVO: Administrador)
	public String logarAdm(){
		return "SELECT * FROM usuario WHERE usuarioLogin = '"+login+"' AND usuarioSenha = '"+senha+"' AND usuarioAtivo = 'S' AND usuarioNivel = '1'";
	}
	
	//Verifica se o nome de Usu�rio j� existe antes de Cadastrar um novo Usu�rio
	public String verificaNome(){
		return "SELECT usuarioLogin FROM usuario WHERE usuarioLogin = '"+login+"'";
	}
	
	//Verifica se o nome de Usu�rio j� existe antes de Alterar um Usu�rio
	public String verificaNomeAlterar() {
		return "SELECT usuarioLogin FROM usuario WHERE usuarioLogin = '"+login+"' AND usuarioID <> '"+usuarioID+"'";
	}
	
	//Busca Usu�rios
	public String pesquisaUsuario(String keyWord) {
		return "SELECT * FROM usuario WHERE usuarionome LIKE '%"+keyWord+"%' ORDER BY usuarioID DESC";
	}
	
	//Metodo para listar todos os usuarios
	public String listaUsuarios(){
		return "SELECT * FROM usuario ORDER BY usuarioID DESC";
	}
	
	//Metodo para listar todos os usuarios Ativos
	public String listaUsuariosAtivos(){
		return "SELECT * FROM usuario WHERE usuarioAtivo = 'S' ORDER BY usuarioID DESC";
	}
	
	//Metodo para pesquisar Usu�rio por ID
	public String usuarioPorID(){
		String busca = "SELECT empresa.empresaID, empresa.unidade, usuario.* ";
		busca += "FROM usuario INNER JOIN empresa ON empresa.empresaID = usuario.empresaID ";
		busca += "WHERE usuario.usuarioID = '"+usuarioID+"'";
		
		return busca;
	}
	
	//Metodo para pesquisar Nome do Usu�rio atrav�s do login
	public String usuarioPorLogin() {
		return "SELECT * FROM usuario WHERE usuarioLogin = '"+login+"'";
	}
	
	//Metodo para listar todos os usu�rios por ordem alfabetica
	public String listaUsuariosOrdenados() {
		return "SELECT * FROM usuario WHERE usuarioAtivo = 'S' ORDER BY usuarioNome ASC";
	}
	
	//Metodo para salvar um novo Cadastro na Base de Dados
	public String salvaUsuario(){
		String inserirNaBase;
		inserirNaBase = "INSERT INTO usuario ";
		inserirNaBase += "(funcionarioID, usuarioNome, usuarioTelefone, usuarioEmail, usuarioLogin, usuarioSenha, usuarioNivel, empresaID) ";
		inserirNaBase += "VALUES ('"+funcionario.funcionarioID+"', '"+nome+"', '', '', '"+login+"', '"+senha+"', '"+nivel+"', '"+empresa.empresaID+"')";
		
		return inserirNaBase;
	}
	
	//Metodo para Editar usuario
	public String editarUsuario(){
		String atualizaUsuario;
		atualizaUsuario = "UPDATE usuario ";
		atualizaUsuario += "SET funcionarioID = '"+funcionario.funcionarioID+"', usuarioNome = '"+nome+"', usuarioLogin = '"+login+"', ";
		atualizaUsuario += "usuarioSenha = '"+senha+"', usuarioNivel = '"+nivel+"', empresaID = '"+empresa.empresaID+"' ";
		atualizaUsuario += "WHERE usuarioID = '"+usuarioID+"'";
		
		return atualizaUsuario;
	}
	
	//Metodo para Excluir usuario
	public String excluiUsuario(){
		return "DELETE FROM usuario WHERE usuarioID = '"+usuarioID+"'";
	}
	
	//Muda Status do usu�rio para ATIVO(S) OU INATIVO(N)
	public String statusUsuario(int numeroAcao){
		
		if(numeroAcao == 1){
			return "UPDATE usuario SET usuarioAtivo = 'N' WHERE usuarioID = '"+usuarioID+"'";
		}else if(numeroAcao == 2){
			return "UPDATE usuario SET usuarioAtivo = 'S' WHERE usuarioID = '"+usuarioID+"'";
		}
		
		return null;
	}
	
	//Metodo de tratamento de Erro 
	public String erro(int numeroErro){
		
		switch (numeroErro) {
		case 1:
			return "Entre com seu login ou senha!";
			
		case 2:
			return "Login ou senha n�o Existe";
			
		case 3:
			return "Sess�o Expirou, entre novamente!";

		default:
			return "";
		}
		
	}
	
	//Metodo de tratamento de Mensagens
	public String mensagem(int numeroMsg){
		
		switch (numeroMsg) {
		case 1:
			return "Usu�rio Cadstrado com Sucesso!";
			
		case 2:
			return "Usu�rio Alterado com Sucesso!";
			
		case 3:
			return "Usu�rio Excluido com Sucesso!";
			
		case 4:
			return "Imposs�vel Cadastrar! J� existe um usu�rio com esse Login.";
		
		case 5:
			return "Imposs�vel Alterar! J� existe um usu�rio com esse Login.";

		default:
			return "";
		}
	}
	
	//Apresenta Niveis de Usu�rio
	public String nivelUsuario(int nivel){
		
		switch (nivel) {
		case 1:
			return "Nivel 1";
			
		case 2:
			return "Nivel 2";
			
		case 3:
			return "Nivel 3";
			
		case 4:
			return "Nivel 4";
			
		case 5:
			return "Nivel 5";
			
		case 6:
			return "Nivel 6";

		default:
			return null;
		}
		
	}

}
