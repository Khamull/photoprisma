
<%@ page import="java.sql.*" %>
<%@ include file="inc/conexao.jsp" %>
<%@ include file="inc/seguranca.jsp" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.ArrayList" language="java" %>
<%@ page language="java" import="java.util.*,java.lang.*" %> 

<jsp:useBean id="servico" class="servico.Servico" scope="page"></jsp:useBean>

<jsp:useBean id="data" class="formatar.Datas" scope="page"></jsp:useBean>

<jsp:useBean id="servicoproduto" class="servico.ServicoProduto" scope="page"></jsp:useBean>

<jsp:useBean id="produto" class="cadastro.Produto" scope="page"></jsp:useBean>

<jsp:useBean id="materiais" class="cadastro.Produto" scope="page"></jsp:useBean>

<jsp:useBean id="produtoestoque" class="cadastro.ProdutoEstoque" scope="page"></jsp:useBean>

<jsp:useBean id="produtos" class="cadastro.Produtos" scope="page"></jsp:useBean>

<jsp:useBean id="insertMateriais" class="servico.ServicoMateriais" scope="page"></jsp:useBean>

<jsp:useBean id="os" class="servico.Servico" scope="page"></jsp:useBean>

<%
//Instancia um objeto do tipo Statement para ajudar na query
Statement st01 = con.createStatement();
Statement st02 = con.createStatement();
Statement st03 = con.createStatement();
Statement st04 = con.createStatement();
Statement st05 = con.createStatement();
Statement st06 = con.createStatement();
Statement st07 = con.createStatement();
Statement st08 = con.createStatement();
Statement st09 = con.createStatement();
Statement st10 = con.createStatement();
Statement st11 = con.createStatement();
%>


<%
//Instancia um objeto do tipo Resultset para receber o resultado de uma busca
ResultSet rs01 = null;
ResultSet rs02 = null;
ResultSet rs03 = null;
ResultSet rs04 = null;
ResultSet rs05 = null;
ResultSet rs06 = null;
ResultSet rs07 = null;
ResultSet rs08 = null;
ResultSet rs09 = null;
ResultSet rs10 = null;
ResultSet rs11 = null;
%>


<%
//Recupera rotinaId do produto Selecionado
GregorianCalendar cal = new GregorianCalendar();//verfica qual o ultimo numero de OS inserido
rs11 = st11.executeQuery(os.ultimoServico_ano(cal.get(Calendar.YEAR)));
if(rs11.next()){
	
	servico.OS = Integer.toString(rs11.getInt("OS")+1);//atribui valor para a OS da classe servico, que fará a inserção do valor.
}
else{
	servico.OS = "1";
}

//Recupera valores do formulário e atribui ao objeto servico
servico.cliente.clienteID 	= Integer.parseInt((String)request.getParameter("clienteID").trim());
servico.empresa.empresaID	= Integer.parseInt((String)session.getAttribute("empresaID"));
servico.descricao			= request.getParameter("descricao");
servico.dataInicio 			= data.converteParaData(data.dataAtual());
servico.valor				= Float.parseFloat(request.getParameter("valorTotal").replace(",","."));
servico.usuario.usuarioID	= Integer.parseInt((String)session.getAttribute("usuarioID"));
//servico.OS 					= request.getParameter("os");
servico.anoServico			= request.getParameter("anoServico");
servico.dataPrevista		= request.getParameter("previcao");




//Executa a Query q irá salvar o Serviço


//Para gerar um cupom pesquisa na base de dados qual foi o último serviço gerado
//rs01 = st01.executeQuery(servico.ultimoServico());

int servicoID = Integer.MIN_VALUE;
st.execute(servico.cadastraServico());
rs01 = st01.executeQuery(servico.ultimoIDReal());
if(rs01.next()){
	servicoID = rs01.getInt("ID");
}

	//Recupera Arrays dos Materiais
	String [] Produtos  = request.getParameterValues("produtoID[]");
	//String [] Altura    =    request.getParameterValues("altura[]");
	//String [] Largura	= request.getParameterValues("largura[]");
	//String [] Quantidade= request.getParameterValues("Quantidade[]");
	//String [] AlturaR    	= request.getParameterValues("alturaR[]");//valores Reais de consumo(com sobra)
	//String [] LarguraR		= request.getParameterValues("larguraR[]");
	String [] QuantidadeR	= request.getParameterValues("qtdProduto[]");
	String [] valorProduto = request.getParameterValues("valorProdutoTotal[]");
	String [] infos = request.getParameterValues("infos[]");
		
	for(int j = 0; j < Produtos.length; j++){
		produtos.produtoID = Integer.parseInt(Produtos[j]);
		servicoproduto.servico.servicoID 	= servicoID;
		servicoproduto.produtos.produtoID	= Integer.parseInt(Produtos[j]);
		servicoproduto.infos = infos[j];
		String valor_ 				= valorProduto[j];
		String qtdProduto			= QuantidadeR[j];
		servicoproduto.servico.servicoID = servicoID;
	
	
	//Insere o produto na base de dados
		st.execute(servicoproduto.salvaProduto(qtdProduto, valor_));
	}

%>


<%
//Direciona para a impressão de um cupom para o cliente
response.sendRedirect("sis_print_cupom_servico_cliente.jsp?servicoID="+servicoID+"&OS="+servico.OS+"&Ano="+servico.anoServico);
//response.sendRedirect("sis_update_os.jsp?servicoID="+servicoID);
%>

<%
//fecha Statment
st.close();
%>