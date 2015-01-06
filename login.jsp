<%@page import="java.sql.*" %>
<%@ include file="inc/conexao.jsp" %>
<jsp:useBean id="usuario" class="cadastro.Usuario" scope="page"></jsp:useBean>
<jsp:useBean id="acesso" class="cadastro.Acesso" scope="page"></jsp:useBean>
<%
//Instancia um objeto do tipo ResultSet para receber resultado de uma Consulta
ResultSet rs = null;
%>

<%
//Verifica se os valores n�o vieram nullos
if(request.getParameter("usuario") != null || request.getParameter("senha") != null){

//Recupera valores que vem do formul�rio alimentando o objeto do Tipo Usuario
usuario.login = request.getParameter("usuario");
usuario.senha = request.getParameter("senha");

	//QUANTO FOR SUBIR PARA O FTP DESCOMENTAR AS SEGUINTES DUAS LINHAS COMENTAR A DEBAIXO
	//usuario.empresa.empresaID = Integer.parseInt(request.getParameter("empresaID"));
	//chama o Metodo que ir� passar a consulta � Base de Dados
	//rs = st.executeQuery(usuario.logarUnidade());
	rs = st.executeQuery(usuario.logar());

//verifica se a consulta trouxe algum registro
//se trouxe � porque existe um usu�rio, se n�o � porque n�o existe
	if(rs.next()){
		//Determina tempo da Sess�o
		session.setMaxInactiveInterval(3600);
		//Salva o Nome do Usuario na Sess�o
		session.setAttribute("usuario", usuario.login);
		//Salva na Sess�o o tipo de usuario
		session.setAttribute("nivel", rs.getString("usuarioNivel"));
		//Salva na Sess�o o ID do usu�rio
		session.setAttribute("usuarioID", rs.getString("usuarioID"));
		//Salva na Sess�o o Status LOGADO
		session.setAttribute("status", "LOGADO");
		//Salva na Sess�o a que Empresa (unidade) esse login pertence
		session.setAttribute("empresaID", rs.getString("empresaID"));
		//Registra o Acesso na tabela acesso na Base de Dados
		acesso.usuario = (String) session.getAttribute("usuario");
		acesso.retornaIP();
		//st.execute(acesso.registraAcesso(request.getRemoteAddr()));	
		//Redireciona para a pagina sis_menu
		int Nivel = 0;
		String Nivel_ = rs.getString("usuarioNivel");
		Nivel = Integer.parseInt(Nivel_);
		switch(Nivel)
		{
			 case 1: 
				response.sendRedirect("sis_menu.jsp");
				break;
			 case 2:
				 response.sendRedirect("sis_menu.jsp");
					break;
			 case 3:	
				 response.sendRedirect("sis_view_servicos.jsp");
					break;
			 case 4:	
				 response.sendRedirect("sis_view_servicos.jsp");
					break;
			 case 5:	
				 response.sendRedirect("sis_view_servicos.jsp");
					break;
			 case 6:	
				 response.sendRedirect("sis_view_servicos.jsp");
					break;
			 case 7:	
				 response.sendRedirect("sis_view_servicos.jsp");
					break;
			 case 8:	
				 response.sendRedirect("sis_view_servicos.jsp");
					break;
			default: 		
				response.sendRedirect("sis_menu.jsp");
		}
		
		
	}else{
		response.sendRedirect("index.jsp?erro=2");
	}

}else{
	response.sendRedirect("index.jsp?erro=1");
}
%>

<%//out.println(acesso.retornaIP());%>