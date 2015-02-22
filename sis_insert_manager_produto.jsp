<%@ page import="java.sql.*" %>
<%@ include file="inc/conexao.jsp" %>

<jsp:useBean id="produto" class="cadastro.Produto" scope="page"></jsp:useBean>

<%
//Instancia um objeto do tipo Statement
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
	produto.tipo.tipoProdutoID 			= Integer.parseInt(request.getParameter("tipoprodutoID"));
	produto.fornecedor.fornecedorID 	= Integer.parseInt(request.getParameter("fornecedorID"));
	produto.nome 						= request.getParameter("nome");
	produto.codigo 						= request.getParameter("codigo");
	produto.unidade 					= request.getParameter("unidade");
	produto.precoCusto 					= Float.parseFloat(request.getParameter("precoCusto"));
	produto.preco 						= 0.00;//Float.parseFloat(request.getParameter("precoVenda"));
	produto.precoServico				= 0.00;//Float.parseFloat(request.getParameter("precoVenda"));
	produto.lucro 						= "0.00";//request.getParameter("lucro");
	produto.lucroServico				= "0.00";//request.getParameter("lucro");
	produto.estoqueMinimo 				= Integer.parseInt(request.getParameter("estoqueMinimo"));
	produto.utilizacao 					= "M";
	produto.Rotina						= Integer.parseInt(request.getParameter("rotina"));
}
else if(request.getParameter("possuiMaterial") != null){
	produto.tipo.tipoProdutoID 			= Integer.parseInt(request.getParameter("tipoprodutoID"));
	produto.fornecedor.fornecedorID 	= Integer.parseInt(request.getParameter("fornecedorID"));
	produto.nome 						= request.getParameter("nome");
	produto.codigo 						= request.getParameter("codigo");
	produto.unidade 					= request.getParameter("unidade");
	produto.precoCusto 					= Float.parseFloat(request.getParameter("precoCusto"));
	produto.preco 						= Float.parseFloat(request.getParameter("precoVenda"));
	produto.precoServico				= Float.parseFloat(request.getParameter("precoVendaServico"));
	produto.lucro 						= request.getParameter("lucro");
	produto.lucroServico				= request.getParameter("lucroServico");
	produto.estoqueMinimo 				= Integer.parseInt(request.getParameter("estoqueMinimo"));
	produto.Rotina						= Integer.parseInt(request.getParameter("rotina"));
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
	produto.tipo.tipoProdutoID 			= Integer.parseInt(request.getParameter("tipoprodutoID"));
	produto.fornecedor.fornecedorID 	= Integer.parseInt(request.getParameter("fornecedorID"));
	produto.nome 						= request.getParameter("nome");
	produto.codigo 						= request.getParameter("codigo");
	produto.unidade 					= request.getParameter("unidade");
	produto.precoCusto 					= Float.parseFloat(request.getParameter("precoCusto"));
	produto.preco 						= Float.parseFloat(request.getParameter("precoVenda"));
	produto.lucro 						= request.getParameter("lucro");
	produto.lucroServico				= request.getParameter("lucroServico");
	produto.estoqueMinimo 				= Integer.parseInt(request.getParameter("estoqueMinimo"));
	produto.Rotina						= Integer.parseInt(request.getParameter("rotina"));
	produto.precoServico				= Float.parseFloat(request.getParameter("precoVendaServico"));
}

%>

<%
//Verifica se já existe um produto com esse Nome
rs = st.executeQuery(produto.produtoNome());

if(rs.next()){
	//Caso exista um Produto com esse Nome, retorna para a Página de Cadastro
	response.sendRedirect("sis_insert_produto.jsp?msg=4");
}else{
	//Senão: Verifica se existe um produto com esse Codigo
	rs01 = st01.executeQuery(produto.produtoCodigo());
	if(rs01.next()){
		//Caso exista um Produto com esse Codigo, retorna para a Página de Cadasto
		response.sendRedirect("sis_insert_produto.jsp?msg=7");
	}else{
		if(request.getParameter("material") != null){
			st02.execute(produto.salvaProdutoMatereial());
			response.sendRedirect("sis_view_produtos_separados.jsp?msg=1");
		}
		else if(request.getParameter("possuiMaterial") != null){
			st02.execute(produto.salvaProdutoPossuiMaterial());
			response.sendRedirect("sis_view_produtos_separados.jsp?msg=1");
		}
		else{
			//Senão: Executa a Função que irá salvar os dados na Base de Dados
			st02.execute(produto.salvaProduto());
			response.sendRedirect("sis_view_produtos_separados.jsp?msg=1");
		}
	}
}
%>

<%
 //fecha a consulta
 st.close();
 rs.close();
%>