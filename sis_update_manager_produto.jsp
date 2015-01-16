<%@ page import="java.sql.*" %>
<%@ include file="inc/conexao.jsp" %>

<jsp:useBean id="produto" class="cadastro.Produto" scope="page"></jsp:useBean>

<%
//Instancia objeto do tipo Statement
Statement st01 = con.createStatement();
Statement st02 = con.createStatement();
%>

<%
//Instancia um objeto do tipo ResultSet para receber resultado de uma Consulta
ResultSet rs = null;
ResultSet rs01 = null;
%>

<%
//Recupera valores trazidos do Formulário de Cadastro de Produto
//Atrubui eles ao objeto produto

if(request.getParameter("material") != null)//Verifica se o produto é material
{
	produto.produtoID 					= Integer.parseInt(request.getParameter("produtoID"));
	produto.tipo.tipoProdutoID 			= Integer.parseInt(request.getParameter("tipoprodutoID"));
	produto.fornecedor.fornecedorID 	= Integer.parseInt(request.getParameter("fornecedorID"));
	produto.nome 						= request.getParameter("nome");
	produto.codigo 						= request.getParameter("codigo");
	produto.unidade 					= request.getParameter("unidade");
	produto.precoCusto 					= Float.parseFloat(request.getParameter("precoCusto"));
	produto.preco 						= 0.00;//Float.parseFloat(request.getParameter("precoVenda"));
	produto.lucro 						= "0.00";//request.getParameter("lucro");
	produto.estoqueMinimo 				= Integer.parseInt(request.getParameter("estoqueMinimo"));
	produto.utilizacao = "M";
}
else if(request.getParameter("possuiMaterial") != null){
	produto.produtoID 					= Integer.parseInt(request.getParameter("produtoID"));
	produto.tipo.tipoProdutoID 			= Integer.parseInt(request.getParameter("tipoprodutoID"));
	produto.fornecedor.fornecedorID 	= Integer.parseInt(request.getParameter("fornecedorID"));
	produto.nome 						= request.getParameter("nome");
	produto.codigo 						= request.getParameter("codigo");
	produto.unidade 					= request.getParameter("unidade");
	produto.precoCusto 					= Float.parseFloat(request.getParameter("precoCusto"));
	produto.preco 						= Float.parseFloat(request.getParameter("precoVenda"));
	produto.lucro 						= request.getParameter("lucro");
	produto.estoqueMinimo 				= Integer.parseInt(request.getParameter("estoqueMinimo"));
	//Recuperar lista de id de materiais e lista de id
	produto.utilizacao = "PM";
	String [] ids = request.getParameterValues("materiaisSel[]");
	String [] Qtds =request.getParameterValues("qtdUtilizar[]");
	String ids_ = "";
	String Qtds_ = "";
	for(int i = 0; i < ids.length; i++){
		ids_ +=  ids[i] + "#";
		Qtds_ += Qtds[i] + "#";
	}
	produto.listaIDMaterias = ids_.substring(0, ids_.length() - 1);
	produto.ListaQtdMatariais = Qtds_.substring(0, Qtds_.length() - 1);

}
else{
	produto.produtoID 					= Integer.parseInt(request.getParameter("produtoID"));
	produto.tipo.tipoProdutoID 			= Integer.parseInt(request.getParameter("tipoprodutoID"));
	produto.fornecedor.fornecedorID 	= Integer.parseInt(request.getParameter("fornecedorID"));
	produto.nome 						= request.getParameter("nome");
	produto.codigo 						= request.getParameter("codigo");
	produto.unidade 					= request.getParameter("unidade");
	produto.precoCusto 					= Float.parseFloat(request.getParameter("precoCusto"));
	produto.preco 						= Float.parseFloat(request.getParameter("precoVenda"));
	produto.lucro 						= request.getParameter("lucro");
	produto.estoqueMinimo 				= Integer.parseInt(request.getParameter("estoqueMinimo"));
}
%>

<%
//Verifica se já existe um produto com esse Nome
rs = st.executeQuery(produto.produtoNomeEditar());

if(rs.next()){
	//Caso exista um Produto com esse Nome, retorna para a Página de Cadastro
	response.sendRedirect("sis_update_produto.jsp?msg=5&produtoID="+produto.produtoID);
}else{
	//Senão: Verifica se já existe um produto come esse Codigo
	rs01 = st01.executeQuery(produto.produtoCodigoEditar());
	if(rs01.next()){
		//Caso exista um produto com esse Codigo, retorna para a Página de Cadastro
		response.sendRedirect("sis_update_produto.jsp?msg=8&produtoID="+produto.produtoID);
	}else{
			st02.execute(produto.alteraProduto());
			response.sendRedirect("sis_view_produtos.jsp?msg=2");
	}
}
%>

<%
 //fecha a consulta
 st.close();
 rs.close();
%>