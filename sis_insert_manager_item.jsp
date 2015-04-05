
<%@ page import="java.sql.*" %>
<%@ include file="inc/conexao.jsp" %>
<%@ include file="inc/seguranca.jsp" %>

<jsp:useBean id="item" class="pdv.VendaItem" scope="page"></jsp:useBean>

<jsp:useBean id="estoque" class="cadastro.Estoque" scope="page"></jsp:useBean>

<jsp:useBean id="produtoEstoque" class="cadastro.ProdutoEstoque" scope="page"></jsp:useBean>
<jsp:useBean id="produto" class="cadastro.Produto" scope="page"></jsp:useBean>
<jsp:useBean id="Split" class="formatar.SplitString" scope="page"></jsp:useBean>



<%
Statement st01 = con.createStatement();
ResultSet rs01 = null;

Statement st02 = con.createStatement();
ResultSet rs02 = null;

Statement st03 = con.createStatement();
ResultSet rs03 = null;

Statement st04 = con.createStatement();
ResultSet rs04 = null;

Statement st05 = con.createStatement();
ResultSet rs05 = null;
//Recupera valores do formulário para salvar como Item da Venda
item.venda.vendaID 		= Integer.parseInt(request.getParameter("vendaID"));
item.produto.produtoID 	= Integer.parseInt(request.getParameter("prodID"));
item.produto.nome 		= request.getParameter("descricao");
item.produto.preco 		= Float.parseFloat(request.getParameter("valorUnitario"));
item.quantidade 		= Float.parseFloat(request.getParameter("quantidade"));
item.total 				= Float.parseFloat(request.getParameter("totalItem"));

produto.produtoID = Integer.parseInt(request.getParameter("prodID"));
rs01 = st01.executeQuery(produto.listaProdutosPorID_());
String utilizacao = "";
String [] MateriaisID= null;
String [] QtdUtilizar = null;
if(rs01.next()){
	utilizacao = rs01.getString("utilizacao");
	
	//Split.entrada = rs01.getString("qtdUtilizar"); 
}
//Caso a utilização retornada para o produtto seja PM, seguiremos para a alteração de estoques dos nateriais

%>


<%
if(utilizacao.equals("P") &&!utilizacao.equals("")){
//Executa a Query q irá salvar o item no banco de dados
st.execute(item.salvaItem());

//Subtrai quantidade adicionada ao pedido do Estoque
estoque.produto.estoque = (Float.parseFloat(request.getParameter("qtddEstoque")) - item.quantidade);
estoque.produto.produtoID = Integer.parseInt(request.getParameter("prodID"));
st.execute(estoque.alteraEstoque());
%>

<%
//Subtrai quantidade adicionao ao pedido do produtoEstoque (do estoque individual do produto por Unidade)
produtoEstoque.produto.produtoID = estoque.produto.produtoID;
produtoEstoque.empresa.empresaID = Integer.parseInt((String)session.getAttribute("empresaID"));
produtoEstoque.quantidade = (Float.parseFloat(request.getParameter("estoqueParcial")) - item.quantidade);
st.execute(produtoEstoque.alteraEstoque());
%>

<%

}
else{
	rs02 = st02.executeQuery(produto.listaProdutosPorID_());
	while(rs02.next()){
		
		
		QtdUtilizar = rs02.getString("qtdUtilizar").split("#");
		MateriaisID = rs02.getString("idsMateriais").split("#");
		//Recuperando os ID's e as quantidades de materais a serem usados
		//Agora preciso pesquisar cada uma dos ID's, analisar cada um dos estoques, e a partir de todos positivos, posso prosseguir
	}
	String Lista="";
	for(int i = 0; i < MateriaisID.length; i++){// a lista de itens para a clausula IN da query
		Lista +="'"+MateriaisID[i]+"',";
	}
	Lista = Lista.substring(0, Lista.length()-1);
	rs03 = st03.executeQuery(produto.listaMateriaisPorId(Lista));
	//st.execute(item.salvaItem());// Ultima coisa que será feita é salvar o item, visto que preciso validar o estoque
	int i = 0;
	float Estocado = 0;
	while(rs03.next()){
		Estocado = rs03.getFloat("estoque");
		if(Estocado >= Float.parseFloat(QtdUtilizar[i]))
		{
			i++;
		}
	}
	int j = 0;
	if(i == MateriaisID.length)
	{
		rs04 = st04.executeQuery(produto.listaMateriaisPorId(Lista));
		while(rs04.next()){
			estoque.produto.estoque = (rs04.getFloat("estoque") - Float.parseFloat(QtdUtilizar[j]));
			estoque.produto.produtoID = Integer.parseInt(MateriaisID[j]);
			st.execute(estoque.alteraEstoque());

			//Subtrai quantidade adicionao ao pedido do produtoEstoque (do estoque individual do produto por Unidade)
			produtoEstoque.produto.produtoID = Integer.parseInt(MateriaisID[j]);
			produtoEstoque.empresa.empresaID = Integer.parseInt((String)session.getAttribute("empresaID"));
			
			//Realiza a pesquisa da quantidade de itens no estoque referente a esse produto na unidade em que está logado
			float estoqueParcial = 0;
			rs05 = st05.executeQuery(produtoEstoque.pesquisaEstoque());
			if(rs05.next()){
				estoqueParcial = Float.parseFloat(rs05.getString("quantidade"));
			}
			produtoEstoque.quantidade = (Float.parseFloat(QtdUtilizar[j]) - estoqueParcial);
			st.execute(produtoEstoque.alteraEstoque());
			j++;
		}
		st.execute(item.salvaItem());
	}
	else
	{
		%>
		<script type="text/javascript">
			alert("Um ou mais materiais do produto não estão disponíveis, favor rever estoque!");
		</script>	
		<%
		response.sendRedirect("sis_gerar_venda.jsp?msg=1");
		return;
	}
}
	
%>

<%
//Direciona para o PDV novamente
response.sendRedirect("sis_gerar_venda.jsp");
//fecha Statment
st.close();
%>