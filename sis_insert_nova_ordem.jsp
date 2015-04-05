<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@page import="servico.ServicoItem"%>
<%@ page import="java.sql.*" %>
<%@ include file="inc/seguranca.jsp" %>
<%@ include file="inc/conexao.jsp" %>

<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat;" %>

<jsp:useBean id="usuario" class="cadastro.Usuario" scope="page"></jsp:useBean>

<jsp:useBean id="cliente" class="cadastro.Cliente" scope="page"></jsp:useBean>

<jsp:useBean id="servico" class="servico.Servico" scope="page"></jsp:useBean>

<jsp:useBean id="date" class="java.util.Date" scope="page"/>

<jsp:useBean id="produtos" class="cadastro.Produtos" scope="page"></jsp:useBean><!--Para Seleção de Produtos que compoem a OS -->

<jsp:useBean id="materiais" class="cadastro.Produto" scope="page"></jsp:useBean><!--Para Seleção de materiais que compoem os produtos -->

<jsp:useBean id="os" class="servico.Servico" scope="page"></jsp:useBean>

<jsp:useBean id="caixa" class="caixaloja.Caixa" scope="page"></jsp:useBean>


<%
GregorianCalendar cal = new GregorianCalendar();
//Instancia um objeto do tipo Statement para ajudar na query
Statement st01 = con.createStatement();
Statement st02 = con.createStatement();
Statement st03 = con.createStatement();
Statement st04 = con.createStatement();
Statement st05 = con.createStatement();
Statement st06 = con.createStatement();
Statement st07 = con.createStatement();

//Instancia um objeto do tipo ResultSet para receber resultado de uma Consulta
ResultSet rs = null;
ResultSet rs01 = null;
ResultSet rs02 = null;
ResultSet rs03 = null;
ResultSet rs04 = null;
ResultSet rs05 = null;
ResultSet rs06 = null;
ResultSet rs07 = null;

//Atribui o nome do usuario ao objeto caixa para realizar
//a consulta posteriormente
caixa.usuario.login = (String)session.getAttribute("usuario");

//Faz a consulta na Base de Dados
rs07 = st07.executeQuery(caixa.verificaCaixa());

if(rs07.next()){
	String Telefone  =""; 
	String Celular   =""; 
	String Operadora =""; 
	//Pesquisa todos os clientes Ativos e/ou pesquisa os dados do cliente selecionado na combobox+dados para seleção novamente
	if(request.getParameter("clienteID") != null){
		//Atribui o ID ao Objeto da Classe Produto
		cliente.clienteID = Integer.parseInt(request.getParameter("clienteID"));
		rs01 = st01.executeQuery(cliente.clienteID());
		rs03 = st03.executeQuery(cliente.clienteDiferenteID());
		rs04 = st04.executeQuery(cliente.clienteID());
	}
	else
	{
		rs01 = st01.executeQuery(cliente.listaClientesaAtivos());
	}
}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>FORTE SYSTEM</title>
<script src="js/jquery-1.4.3.min.js"></script>
<script type="text/javascript" src="js/interface.js"></script>

<!--[if lt IE 7]>
 <style type="text/css">
 .dock img { behavior: url(iepngfix.htc) }
 </style>
<![endif]-->   

<link href="css/menu.css" rel="stylesheet" type="text/css" />
<link href="css/geral.css" rel="stylesheet" type="text/css" />
</head>
<body>
<div id="container">
	<div id="topo">
	 	<jsp:include page="inc/menu_superior.jsp" />
	</div>
	<div id="corpo">
		<table width="985" align="center" height="440">
		</table>
	</div>
</div>
</body>
</html>