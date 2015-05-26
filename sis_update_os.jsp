<%@page import="servico.ServicoProduto"%>
<%@ page import="java.sql.*" %>
<%@ include file="inc/seguranca.jsp" %>
<%@ include file="inc/conexao.jsp" %>

<jsp:useBean id="servico" class="servico.Servico" scope="page"></jsp:useBean>

<jsp:useBean id="servicoitem" class="servico.ServicoItem" scope="page"></jsp:useBean>

<jsp:useBean id="servicoproduto" class="servico.ServicoProduto" scope="page"></jsp:useBean>

<jsp:useBean id="data" class="formatar.Datas" scope="page"></jsp:useBean>

<%
//Instancia um objeto do tipo Statement para ajudar na query
Statement st01 = con.createStatement();
Statement st02 = con.createStatement();
Statement st03 = con.createStatement();
Statement st04 = con.createStatement();
Statement st05 = con.createStatement();
%>


<%
//Instancia um objeto do tipo ResultSet para receber resultado de uma Consulta
ResultSet rs = null;
ResultSet rs01;
ResultSet rs11;
ResultSet rs03;
ResultSet rs04;
ResultSet rs05;
%>


<%
//Recupera o ID do Serviço trazido via URL e atribui ao objeto servico
servico.servicoID = Integer.parseInt(request.getParameter("servicoID"));
//String id = "href=\"sis_print_cupom_servico_cliente.jsp?servicoID="+request.getParameter("servicoID")+"\"";
String id = "sis_print_cupom_servico_cliente.jsp?servicoID="+request.getParameter("servicoID");
%>


<%
//Pesquisa informações sobre o Serviço
rs = st.executeQuery(servico.pesquisaServico());
%>


<%
//Psquisa todos os itens adicionados ao Serviço
servicoitem.servico.servicoID = servico.servicoID;
rs01 = st01.executeQuery(servicoitem.listaItens());
%>


<%
//Pesquisa todos os produtos adicionados ao Servico
servicoproduto.servico.servicoID = servico.servicoID;
rs11 = st02.executeQuery(servicoproduto.listaProdutos());
%>

<%
//Converte para o Formato Data
Currency currency = Currency.getInstance("BRL");

DecimalFormat formato = new DecimalFormat("R$ #,##0.00");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="java.util.Currency"%>
<%@page import="java.text.DecimalFormat"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-2" />
<title>FORTE SYSTEM</title>

<script type="text/javascript">
function dataprevistaVerifica()
{
	var dataprevista_ = ocument.getElementById("previsao");
	if(dataprevista_.value == "")
		{
			alert("Preencha a data prevista antes de Abrir a Ordem de Serviço");
		}
}
function verForm(){
	
}

function alterarProd(servicoProdutoID, servicoID ,prodID){
	if (confirm("Editar Produtos?")){
		window.location.href = "sis_update_os.jsp?servicoID="+servicoID+"&altera=0";
	}	
}

function addServico(servicoID){
	if (confirm("Adicionar Servico?")){
		window.open("sis_add_servico.jsp?servicoID="+servicoID+" ", "Adicionar", "width=450px, height=250px");
	}	
}

function addProduto(servicoID){
	if (confirm("Adicionar Produto?")){
		window.open("sis_add_produto.jsp?servicoID="+servicoID+" ", "Adicionar", "width=500px, height=250px");
	}
}

function excluir(servicoitemID, servicoID){
	if(confirm("Tem certeza que deseja Excluir esse Serviço?")){
		window.location.href="sis_exc_manager_servico.jsp?servicoitemID="+servicoitemID+"&servicoID="+servicoID;
	}
}

function excluirProd(servicoprodutoID, servicoID, prID){
	if(confirm("Tem certeza que deseja Excluir esse Produto?")){
		window.location.href="sis_exc_manager_produto.jsp?servicoprodutoID="+servicoprodutoID+"&servicoID="+servicoID+"&prodID="+prID;
	}
}


function dataPrevisao(servicoID, obj){
		window.location.href="sis_manager_dataprevista.jsp?servicoID="+servicoID+"&dataprevista="+obj.value;
}

function caminho(servicoID, obj){
	window.location.href="sis_manager_caminho.jsp?servicoID="+servicoID+"&caminho="+obj.value;
}
function SalvarProd(servicoID){
	var produto 	= document.getElementById("prd").value;
	var altura 		= document.getElementById("altura").value;
	var largura 	= document.getElementById("largura").value;
	var qtd		= document.getElementById("qtd").value;
	var Destino 	= "sis_manager_updateos.jsp?servicoID="+servicoID
	Destino += "&prd="+produto;
	Destino += "&largura="+largura;
	Destino += "&altura="+altura;
	Destino += "&qtd="+qtd;
	window.location.href= Destino;
}

</script>

<script type="text/javascript" src="js/jquery.js"></script>


<script type="text/javascript" src="js/jquery-1.4.3.min.js"></script>
    <script type="text/javascript" src="js/jquery.pstrength-min.1.2.js"></script>
        <script>
        	$(document).ready(function(){
				$('.password').pstrength();
			});
        </script>

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
<tr>
 <td height="25" bgcolor="#EEEEEE">
 <input type="button" class="botao" onclick="javascript: window.location.href='sis_view_servicos.jsp'" value="Lista de OS's" />&nbsp;
 <input type="button" class="botao" onclick="javascript: window.location.href='sis_insert_servico.jsp'" value="+ Nova OS" />
 </td>
</tr>
<tr>
 <td height="25"></td>
</tr>
<tr>
 <td valign="top" align="center">
 <%if(rs.next()){ 	%>
 <table width="696" align="center" cellpadding="2" cellspacing="2">
  <tr bgcolor="#EEEEEE">
   <td colspan="6" align="center"><strong>EDITAR ORDEM DE SERVI&Ccedil;O</strong></td>
  </tr>
  <tr>
  	<form id="form1" action="<%=id%>" method="post">
    <td align="left">N&deg; Ordem Servi&ccedil;o</td>
    <td align="left"><%=rs.getString("OS")+"/"+rs.getString("anoServico").substring(0,4) %></td>
    <td width="52" align="left">Cliente</td>
    <td width="240" align="left"><%=rs.getString("clienteNomeFantasia") %></td>
  </tr>
  <tr>
    <td width="66" align="left">Inicio</td>
    <td width="164" align="left"><%=data.converteDeData(rs.getString("dataInicio")) %></td>
    <td align="left" width="164"><strong></>Data Prevista :
    <%if(!rs.getString("dataprevista1").equals("0")){%>
    	<%=data.converteDeData(rs.getString("dataprevista1")) %></TD>
    <%}
    else
    {%>
    	<input type="date" value="" name="previsao" id="previsao" required style="width:125px" onchange="dataPrevisao(<%=rs.getString("servicoID") %>, this);" /></strong></TD>
    <%}%>
    <td colspan="2" align="left">
    Tel: <%=rs.getString("clienteTelefone") %> &nbsp;&nbsp;&nbsp;
    Cel: <%=rs.getString("clienteCelular") %> <%=rs.getString("operadoraCelular") %>
    </td>
    <TD coslpan="2"><%=rs.getString("clienteEmail") %></TD>
    </tr>
  <tr bgcolor="#F9F6F2">
    <td align="left">VALOR TOTAL</td>
    <td align="left"><font color="#009900"><strong><%=formato.format(rs.getDouble("valor")) %></strong></font></td>
    <td colspan="4"  align="left">
	    &Uacute;ltima Altera&ccedil;&atilde;o&nbsp; &nbsp; <%=data.converteDeData(String.valueOf(rs.getDate("dataFim"))) %>
	    <input type="button" name="concluir" onclick="javascript: window.location.href='sis_finalizar_servico.jsp?servicoID=<%=rs.getString("servicoID")%>&OS=<%=rs.getString("OS")%>&Ano=<%=rs.getString("anoServico").substring(0,4)%>'" style="background-color:transparent; background-image:url(images/icone-financeiro.png); background-repeat:no-repeat; width:200px; height:22px; border:0; background-size:15% 100%;
	-webkit-background-size:15% 100%;
	-o-background-size: 15% 100%;
	-khtml-background-size: 15% 100%;
	-moz-background-size: 15% 100%;" value="" title="Pagamentos" />
	</td>
    </tr>
    <tr>
    	<td align="left">ENTRADA</td>
    	<%rs05 = st05.executeQuery(servico.valoresJaPagos(rs.getString("OS"), rs.getString("anoServico")));
    	if(rs05.next()){%>
    		<td align="left"><font color="#009900"><strong><%=formato.format(rs05.getDouble("entrada")) %></strong></font></td>
    	<%} %>
    </tr>
  <tr bgcolor="#FFFF99">
   <td colspan="6" align="center">Descri&ccedil;&atilde;o do Servi&ccedil;o&nbsp;<a href="sis_update_descricao_servico.jsp?servicoID=<%=rs.getString("servicoID")%>" style="font-size:10px" title="Editar Descriçao do Serviço">[editar]</a></td>
   </tr>
  <tr>
   <td colspan="6" align="center">
    <pre style="white-space:pre-line; width:696px; text-align:left"><%=rs.getString("descricao")%></pre>   </td>
  </tr>
  <tr>
    <td colspan="6" align="center"><hr color="#FFFF99" /></td>
  </tr>
  <tr align="center" valign="middle" bgcolor="#52658C">
    <td colspan="6"><font color="#FFFFFF">Produto&nbsp;</font><!-- a href="javascript: addProduto(<%=rs.getString("servicoID")%>)" ><img src="ico/ico_add.png" width="18" height="18" border="0" align="absmiddle" title="+ Adicionar Produto" /></a--></td>
    </tr>
    <tr>
    	<table>
<%while(rs11.next()){	
				if(rs11.getInt("rotina") == 0){%>
					 	<tr bgcolor="#EEEEEE" align="center">
					 		<td><strong>Nome</strong></td>
					 		<td><strong>Qtd</strong></td>
					 		<td><strong>Valor</strong></td>
					 		<td><strong>Qtd</strong></td>
					 		<td><strong>Laboratório</strong></td>
					 		<td><strong>Dt. Envio</strong></td>
					 		<td><strong>Prev. Ret.</strong></td>
					 		<td><strong>Ret. Real</strong></td>
					 		<td><strong>Fase</strong></td>
					 		<td><strong>Informações</strong></td>
					 		<td><strong>Visualizado</strong></td>
					 		<td><strong>Finalizado</strong></td>
					 	</tr>
					 	<tr align="center">
					 		<td><%=rs11.getString("nome") %></td>
					 		<td><%=rs11.getString("qtdProduto") %></td>
					 		<td><%=formato.format(rs11.getFloat("valor")) %></td>
					 		<td><%=rs11.getString("qtdProduto") %></td>
					 		<%if(!rs11.getString("laboratorio").equals("Digite")){ %>
					 			<td style="max-width: 90px;"><%=rs11.getString("laboratorio") %></td>					 			
					 		<%}else{ %>
								<td style="max-width: 90px;"></td>					 			
					 		<%} %>
					 		<%if(!rs11.getString("DataEnvio1").equals("0")){ %>
					 			<td><%=data.converteDeData(rs11.getString("DataEnvio1")) %></td>
					 		<%}else{ %>
								<td></td>					 			
					 		<%} %>				 		
					 	<%if(!rs11.getString("DataEnvio1").equals("0")){ %>
					 		<%if(!rs11.getString("DataPrevista").equals("0")){%>
					 			<td><%=data.converteDeData(rs11.getString("DataPrevista")) %></td>
					 		<%}else{ %>
								<td></td>					 			
					 		<%}
					 		}else{%>
					 			<td></td>
					 		<%}%>
					 		<%if(!rs11.getString("DataReal").equals("0")){ %>
					 			<td><%=data.converteDeData(rs11.getString("DataReal")) %></td>
					 		<%}else{ %>
								<td></td>					 			
					 		<%} %>
					 		<%if(!rs11.getString("fase").equals("inicio")){ %>
					 			<td><%=rs11.getString("fase") %></td>
					 		<%}else{ %>
					 			<td><%=rs11.getString("fase") %></td>
					 		<%} %>
					 		<td><%=rs11.getString("infos") %></td>
					 		<%if(rs11.getInt("visualizado") != 1){ %>
					 			<td><img src="ico/ico_visualizar.png" width="20" height="20" border="0" title="Informar Início do Serviço" /></td>
					 		<%}else{%>
					 				<td><img src="ico/ico_joinha.png" width="20" height="20" border="0" title="Serviço Iniciado Por: <%=rs11.getString("UsuarioVisualizador") %>" /></td>
					 		<%} %>
					 		<%if(rs11.getInt("Finalizado") == 0) {%>
					 		<%if(rs11.getInt("visualizado") == 1){ %>
					 			<%if(!rs11.getString("DataReal").equals("0")) {%>
					 				<td><img src="ico/ico_cofirmar.gif" width="20" height="20" border="0" title="Clique aqui para confirmar Finalizacao"/></td>
								<%}else{ %>
									<td><img src="ico/ico_cofirmar.gif" width="20" height="20" border="0" title="Informe data real de retorno para poder Finalizar!"/></td>
								<%} %>					 			
					 		<% }else{%>
					 				<td><img src="ico/ico_cofirmar.gif" width="20" height="20" border="0" title="Necessário Iniciar o Serviço Para Finaliza-lo!"/></td>
					 		<%}
					 		}else{ %>
					 			<td><img src="ico/ico_cofirmar.gif" width="20" height="20" border="0" title="Finalizado Por: <%=rs11.getString("UsuarioFinalizador") %>"/></td>
					 		<%} %>
					 		
					 		
					 	</tr>
					 	<tr>
    						<td colspan="12" align="center" style="height:1px"><hr style="border:1px solid #333333" /></td>
   						</tr>
					<%
					}
					if(rs11.getInt("rotina") == 1){%>
						<tr bgcolor="#EEEEEE" align="center">
				 		<td><strong>Nome</strong></td>
				 		<td><strong>Qtd</strong></td>
				 		<td><strong>Valor</strong></td>
				 		<td><strong>Prev. Ret.</strong></td>
				 		<td><strong>Fase</strong></td>
				 		<td><strong>Informações</strong></td>
				 		<td><strong>Visualizado</strong></td>
				 		<td><strong>Finalizado</strong></td>
				 	</tr>
				 	<tr align="center">
				 		<td><%=rs11.getString("nome") %></td>
				 		<td><%=rs11.getString("qtdProduto") %></td>
				 		<td><%=formato.format(rs11.getFloat("valor")) %></td>
				 		<%if(!rs11.getString("DataPrevista").equals("0")){%>
				 			<td><input type="date" name="dataPrevistaRetorno" id="<%=rs11.getString("produtoID") %>" value="<%=rs11.getString("DataPrevista") %>" /></td>
				 		<%}else{ %>
							<td><input type="date" name="dataPrevistaRetorno" id="<%=rs11.getString("produtoID") %>"/></td>					 			
				 		<%} %>
				 		<td><%=rs11.getString("fase") %></td>
				 		<td><%=rs11.getString("infos") %></td>
				 		<td><a href="javascript: confirma(<%=rs11.getString("servicoID")%>)"><img src="ico/ico_visualizar.png" width="20" height="20" border="0" title="Visualizar Detalhes do Serviço" /> </a></td>
				 		<td><a href="javascript: confirmaFinalizacao(<%=rs11.getString("servicoID")%>, <%=rs.getString("OS") %>)" onclick="fase(<%=rs11.getString("fase")%>)"><img src="ico/ico_cofirmar.gif" width="20" height="20" border="0" title="Clique aqui para confirmar Finalizacao"/></a></td>
				 	</tr>
				 	<tr>
						<td colspan="12" align="center" style="height:1px"><hr style="border:1px solid #333333" /></td>
						</tr>
					<%}
			}
			%>
</table>
    </tr>
  <tr>
    <td align="left">&nbsp;</td>
    <td align="left">&nbsp;</td>
    <td align="left">&nbsp;</td>
    <td align="left">&nbsp;</td>
  </tr>
 </table>
 <%} %>
 </td>
</tr>
</table>
</div>

<div id="rodape"><jsp:include page="inc/rodape.jsp" /></div>

</div>

<script type="text/javascript">
	
	$(document).ready(
		function()
		{
			$('#dock').Fisheye(
				{
					maxWidth: 50,
					items: 'a',
					itemsText: 'span',
					container: '.dock-container',
					itemWidth: 40,
					proximity: 50,
					halign : 'center'
				}
			)
		}
	);

</script>

</body>
</html>