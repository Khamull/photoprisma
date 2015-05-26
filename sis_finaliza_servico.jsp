<%@ include file="inc/conexao.jsp" %>
<%@page import="cadastro.Usuario" %>
<%@ page errorPage="index.jsp?erro=3" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*,java.util.Date, java.text.*" %>
<%@ include file="inc/seguranca.jsp" %>
<jsp:useBean id="datas" class="formatar.Datas" scope="page"></jsp:useBean>
<jsp:useBean id="produto" class="cadastro.Produto" scope="page"></jsp:useBean>
<jsp:useBean id="produtoServico" class="servico.ServicoProduto" scope="page"></jsp:useBean>
<%

Statement st01 = con.createStatement();
Statement st02 = con.createStatement();
Statement st04 = con.createStatement();
Statement st05 = con.createStatement();
ResultSet rs02 = null;
ResultSet rs05 = null;

Statement st03 = con.createStatement();

String usuarioID = (String) session.getAttribute("usuarioID");
		
	if(request.getParameter("servicoID") != null || request.getParameter("servicoID") != ""){
		
		String selecione ="";
		String selecione2 ="";
		selecione += "select * from servicoproduto where servicoID ='"+ request.getParameter("servicoID")+"' and servicoFinalizado <> 1 ";
		selecione2 += "select COUNT(*) as tot from servicoproduto where servicoID ='"+ request.getParameter("servicoID")+"' and servicoFinalizado <> 1 ";
		rs05 = st05.executeQuery(selecione2);
		rs02 = st02.executeQuery(selecione);
		int tot = 0;
		if(rs05.next())
		{
			tot = rs05.getInt("tot");
		}
		
		int contador = 0;
		
		while(rs02.next())
		{
			String fase = rs02.getString("fase").replace(".", "").trim();
			if(fase.equals("Frente Loja")){
				contador++;
			}
		}
		if(contador == tot){
		
				String Update = "";
				Update += "UPDATE `servico` SET finalizado= 'S' WHERE servicoID = " + request.getParameter("servicoID");  
				st03.execute(Update);
				out.println("Serviço Finalizado com Sucesso!");
		}
		else
		{
			out.println("Serviço ainda possui itens a serem finalizados!");
		}
	}


%>