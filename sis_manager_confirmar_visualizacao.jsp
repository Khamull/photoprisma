<%@ include file="inc/conexao.jsp" %>
<%@page import="cadastro.Usuario" %>
<%@ page errorPage="index.jsp?erro=3" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*,java.util.Date, java.text.*" %>
<%@ include file="inc/seguranca.jsp" %>
<jsp:useBean id="datas" class="formatar.Datas" scope="page"></jsp:useBean>
<jsp:useBean id="produto" class="cadastro.Produto" scope="page"></jsp:useBean>
<jsp:useBean id="produtoServico" class="servico.ServicoProduto" scope="page"></jsp:useBean>
<jsp:useBean id="servico" class="servico.Servico" scope="page"></jsp:useBean>
<jsp:useBean id="servicoproduto" class="servico.ServicoProduto" scope="page"></jsp:useBean>

<%
Statement st01 = con.createStatement();
Statement st02 = con.createStatement();
Statement st04 = con.createStatement();
ResultSet rs02 = null;

Statement st03 = con.createStatement();



Date date = new Date();
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");  
String dataStr = sdf.format(date);
String dataPrevistaRetorno = "";
if(request.getParameter("rotina").equals("0")){
	dataPrevistaRetorno = datas.somaIntervalo(dataStr, Integer.parseInt(request.getParameter("prazo")));
}

String usuarioID = (String) session.getAttribute("usuarioID");

if(request.getParameter("produtoID") != null ||request.getParameter("produtoID")!= "" )
{
	if(request.getParameter("servicoID") != null || request.getParameter("servicoID") != ""){
		if(request.getParameter("servicoprodutoID") != null || request.getParameter("servicoprodutoID") != ""){
			//Fazer o Update do Item a ser alterado, efetuar  a inserção do produto novamente.
			String Update = "";
			Update += "UPDATE `servicoproduto` "; 
			Update += " SET   `finalizado`		= 1 ";
			Update += ", usuarioFinalizadorID = "+usuarioID;
			Update += ", servicoFinalizado = 1";
			Update += " WHERE `servicoprodutoID` ="+ request.getParameter("servicoprodutoID"); 
			Update += " and   `servicoID`        ="+ request.getParameter("servicoID"); 
			Update += " and	  `produtoID`        ="+ request.getParameter("produtoID"); 
			Update += " and   `finalizado`       = 0 ";
			st01.execute(Update);
			
			String insert = "";
			insert += "INSERT INTO `servicoproduto` ";
			insert += "(`servicoID`,";
			insert += " `produtoID`, ";
			insert += " `valor`, ";
			insert += " `qtdProduto`, ";
			insert += " `Laboratorio`, ";
			insert += " `dataEnvio`, ";
			insert += " `dataPrevistaRetorno`, ";
			insert += " `dataRealRetorno`, ";
			insert += " `usuarioID`, ";
			insert += " `visualizado`, ";
			insert += " `usuarioVisualizadoID`, ";
			insert += " `finalizado`, "; 
			insert += " `usuarioFinalizadorID`, ";
			insert += " `fase`, ";
			insert += " `obsfase`, ";
			insert += " `infos`, ";
			insert += " `data`, ";
			insert += " `servicoFinalizado`)";
			insert += " SELECT "; 
			insert += " `servicoID`, "; 
			insert += " `produtoID`, "; 
			insert += " `valor`, "; 
			insert += " `qtdProduto`, "; 
			insert += " `Laboratorio`, "; 
			insert += " `dataEnvio`, "; 
			insert += " `dataPrevistaRetorno`, "; 
			insert += " `dataRealRetorno`, "; 
			insert += " `usuarioID`, "; 
			insert += " `visualizado`, ";
			insert += " `usuarioVisualizadoID`, ";
			insert += " `finalizado`, "; 
			insert += " `usuarioFinalizadorID`, ";
			insert += " `fase`, ";
			insert += " `obsfase`, ";
			insert += " `infos`, ";
			insert += " `data`, ";
			insert += " `servicoFinalizado` "; 
			insert += " FROM `servicoproduto` ";
			insert += " WHERE `servicoprodutoID` ="+ request.getParameter("servicoprodutoID"); 
			insert += " and   `servicoID`        ="+ request.getParameter("servicoID"); 
			insert += " and	  `produtoID`        ="+ request.getParameter("produtoID"); 
			insert += " and   `finalizado`       = 1 ";
			st02.execute(insert);
			int servicoprodutoID = Integer.parseInt(request.getParameter("servicoprodutoID")) + 1;
			rs02 = st04.executeQuery("select last_insert_id() as servicoprodutoID from servicoproduto");
			if(rs02.next())
			{
				servicoprodutoID = rs02.getInt("servicoprodutoID");
			}
			if(request.getParameter("rotina").equals("0")){
				Update = "";
				Update += "UPDATE `servicoproduto` "; 
				Update += " SET   `Laboratorio`		= '"+ request.getParameter("lab") +"', ";
				Update += " fase 					= "+ "'Reenv. Lab.',";
				Update += " dataEnvio = '" + dataStr +"'";
				Update += ", dataPrevistaRetorno = '"+dataPrevistaRetorno + "'";
				Update += ", obsfase = '"+request.getParameter("razao") + "'";
				Update += ", usuarioID = "+usuarioID;
				Update += ", finalizado = 0 ";
				Update += ", visualizado = 1 ";
				Update += ", servicoFinalizado = 0 ";
				Update += ", usuarioVisualizadoID = " + usuarioID;
				Update += ", servicoFinalizado = 0 ";
				Update += " WHERE `servicoprodutoID` ="+ servicoprodutoID; 
				Update += " and   `servicoID`        ="+ request.getParameter("servicoID"); 
				Update += " and	  `produtoID`        ="+ request.getParameter("produtoID");
			}else{
				Update = "";
				String fase = request.getParameter("fase").trim();
				Update += "UPDATE `servicoproduto` "; 
				//Update += " SET   `Laboratorio`		= '"+ request.getParameter("lab") +"', ";
				if(fase.equals("inicio")){
					Update += "SET  fase 					= "+ "'Ed. Arte'";
				}
				if(fase.equals("Agd. Prd.")){
					Update += "SET fase 					= "+ "'Prod.'";
				}
				if(fase.equals("Ret. Prod.")){
					Update += "SET fase 					= "+ "'Conferencia '";
				}
				Update += ", usuarioID = "+usuarioID;
				Update += ", finalizado = 0 ";
				Update += ", visualizado = 1 ";
				Update += ", servicoFinalizado = 0 ";
				Update += ", usuarioVisualizadoID = " + usuarioID;
				Update += ", servicoFinalizado = 0 ";
				Update += " WHERE `servicoprodutoID` ="+ servicoprodutoID; 
				Update += " and   `servicoID`        ="+ request.getParameter("servicoID"); 
				Update += " and	  `produtoID`        ="+ request.getParameter("produtoID");
			}
			
			st03.execute(Update);
			//out.println("Laboratorio registrado com sucesso!#"+dataStr+"#"+dataPrevistaRetorno);
		}
	}
}
response.sendRedirect("sis_view_servicos.jsp");
%>
