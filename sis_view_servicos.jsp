<%@page import="cadastro.Usuario" %>

<%@ page import="java.sql.*" %>
<%@ include file="inc/seguranca.jsp" %>
<%@ include file="inc/conexao.jsp" %>

<jsp:useBean id="usuario" class="cadastro.Usuario" scope="page"></jsp:useBean>

<jsp:useBean id="servico" class="servico.Servico" scope="page"></jsp:useBean>

<jsp:useBean id="data" class="formatar.Datas" scope="page"></jsp:useBean>


<%
//Instancia um objeto do tipo Statement para ajudar query
Statement st01 = con.createStatement();
Statement st09 = con.createStatement();
Statement st11 = con.createStatement();

String idUsu = (String) session.getAttribute("usuarioID");//recupera ID do usuário
String nivel = (String) session.getAttribute("nivel");//recupera ID do usuário
%>

<%
//Instancia um objeto do tipo ResultSet para receber resultado de uma Consulta
ResultSet rs = null;
ResultSet rs01 = null;
ResultSet rs09 = null;
ResultSet rs11 = null;
%>


<%
int dias = 0;
servico.empresa.empresaID = Integer.parseInt((String)session.getAttribute("empresaID"));

String user = (String) session.getAttribute("usuarioID");//recupera ID do usuário

//Pesquisa todos os Serviços cadastrados no sistema ou por Cliente
if(request.getParameter("nome_") != null)
{
	String nome = request.getParameter("nome_");
	rs = st.executeQuery(servico.listaServicosPendentesPorNomeS(nome));
	
}
else
{
	if(request.getParameter("os_")  != null){
		String OS = request.getParameter("os_");
		String ano = OS.substring(OS.length()-4, OS.length());
		String ID = OS.substring(0, OS.length()-5);
		rs = st.executeQuery(servico.listaServicosPendentes_OS(ID,ano));
	}
}
if(session.getAttribute("nivel").equals("1") || session.getAttribute("nivel").equals("2")){//Se administrativo ou Atendimento
	rs = st.executeQuery(servico.listaServicosPendentesNovo());
	
}
if(session.getAttribute("nivel").equals("3") || session.getAttribute("nivel").equals("4"))//Se Sala de edição ou Produção
{
	rs = st.executeQuery(servico.listaServicosPendentesPorCamada((String) session.getAttribute("nivel")));
}
else
{
	if(session.getAttribute("nivel").equals("1") || session.getAttribute("nivel").equals("2"))
	{
		if(request.getParameter("todos") != null)//Se a pessoa tem os níveis certos, porem fez uma consulta
		{
			rs = st.executeQuery(servico.listaServicosPendentesNovo());
		}
		else
		{
			if(request.getParameter("BUSCAR") == null && request.getParameter("todosOrcamentos") == null){	
			//rs = st.executeQuery(servico.listaServicosPendentes());
				rs = st.executeQuery(servico.listaServicosPendentesPorCamada((String) session.getAttribute("nivel")));
			}
			else
			{
				if(request.getParameter("todosOrcamentos") != null)
					rs = st.executeQuery(servico.listaOrcamentos((String) session.getAttribute("nivel")));
			}
		}
	}
	else
	{
		if(request.getParameter("todos") != null)
		{
			rs = st.executeQuery(servico.listaServicosPendentesNovo());
		}
		else{
			if(request.getParameter("BUSCAR") == null){
				if(!session.getAttribute("nivel").equals("7"))
				{	
					if(session.getAttribute("nivel").equals("8"))
					{
						rs = st.executeQuery(servico.listaServicosPendentesPorCamadaRotina2((String) session.getAttribute("nivel")));
					}
					else
					{
						rs = st.executeQuery(servico.listaServicosPendentesPorCamada((String) session.getAttribute("nivel")));
					}
				}
				else
				{
					rs = st.executeQuery(servico.listaOrcamentosPendentes((String) session.getAttribute("nivel")));
				}
			}
		}
		
	}
}


%>


<%
//Trata mensagens
//variaveis que serão utilizadas para verificação
String msg = "";
int numeroMsg;
//verifica se foi passado alguma mensagem via URL
if(request.getParameter("msg") != null){
	numeroMsg = Integer.parseInt(request.getParameter("msg"));
	msg = servico.mensagem(numeroMsg);
}
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
function verForm(){
	
}


function confirma(produtoID, servicoID, servicoprodutoID, fase, rotina){
	if(confirm("Deseja Confirmar a Início desse Serviço?")){
		window.location.href="sis_manager_confirmar_visualizacao.jsp?servicoID="+servicoID+"&servicoprodutoID="+servicoprodutoID+"&produtoID="+produtoID+"&fase="+fase+"&rotina="+rotina;
	}
}


//Encerra por fim a OS
function confirmaFinalizacao(produtoID, servicoID, servicoprodutoID, fase, rotina){
	
		if(confirm("Finalizar Esta Parte do Serviço?"))
		{
			//alert(caminho.value);
			window.location.href="sis_manager_confirmar_finalizacao.jsp?servicoID="+servicoID+"&servicoprodutoID="+servicoprodutoID+"&produtoID="+produtoID+"&fase="+fase+"&rotina="+rotina;
		}
	
}


	
	
//Verifica e Encaminha tarefa para o departamento selecionado	
function confirmaEncaminhamento(servicoID, nivelUsuario, obj){
	
	if(nivelUsuario == "3"){
			var caminho = document.getElementById("caminho");
			if(caminho.value == "")
			{
					alert("Preencha o Caminho da Arte Antes de Encaminhar Tarefa");
			}
			else
			{
				if(confirm("Deseja Realmente Encaminhar esta Tarefa?"))
				{
					//alert(caminho.value);
					window.location.href="sis_manager_encaminhar.jsp?servicoID="+servicoID+"&nivelusuario="+nivelUsuario+"&caminho="+caminho.value+"&dpto="+obj.value;
				}
			}
		
	}
	 else 
	 {
		if(confirm("Deseja Realmente Encaminhar esta Tarefa?"))
		{
			window.location.href="sis_manager_encaminhar.jsp?servicoID="+servicoID+"&nivelusuario="+nivelUsuario+"&caminho=&dpto="+obj.value;
        }
	}
}

function solicitaReagendamento(servicoID, OS, ano, nivelUsuario)
{
	if(confirm("Deseja Realmente Solicitar Reagendamento?"))
	{
		window.open("sis_solicita_reagendamento.jsp?servicoID="+servicoID+"&OS="+OS+"&ano="+ano+"&nivelUsuario="+nivelUsuario, "Reagendar", "width=480px, height=300px");
	}
}

function reagenda(servicoID, OS, ano, nivelUsuario)
{
	if(confirm("Reagendar?"))
	{
		window.open("sis_reagenda.jsp?servicoID="+servicoID+"&OS="+OS+"&ano="+ano+"&nivelUsuario="+nivelUsuario, "Reagendar", "width=480px, height=300px");
	}
}

function reenvia(produtoID, servicoID, servicoprodutoID, fase, prazo, OS, ano)
{
	if(confirm("Reenviar para Laboratório?"))
	{
		window.open("sis_reenvia.jsp?servicoID="+servicoID+"&OS="+OS+"&ano="+ano+"&servicoprodutoID="+servicoprodutoID+"&produtoID="+produtoID+"&fase="+fase+"&prazo="+prazo,
				"Reenviar", "width=480px, height=300px");
	}
}

function excluir(OS, ANO)
{
	if(confirm("Deseja Realmente escluir a OS: "+OS+"/"+ANO))
	{
		window.location.href = "sis_permitir_exclusao_os.jsp?OS="+OS+"&ANO="+ANO;
	}
}

function exibe_esconde(obj)
{
	var ID = obj.id;
	var div = document.getElementById("detalhes"+ID);
	if(div.style.visibility == "visible"){
		div.style.visibility = 'hidden';
		div.style.display = 'none';
	}
	else{
		div.style.visibility = 'visible';
		div.style.display = 'block';
	}
}

function insereData (produtoID, servicoID, servicoprodutoID, obj, tipo){//AlteraDatas do Produto do Serviço
//	var idObj = obj.id;
//	var valor = document.getElementById("val"+idObj);
//	var valor1 = document.getElementById("valT"+idObj);
	//valor.value = "1000,00";
	$.post('sis_insere_datas.jsp', {dataPrevista: obj.value, produtoID: produtoID, servicoID: servicoID, servicoprodutoID: servicoprodutoID, tipo: tipo}, function(data){
		location.reload();
	});
}




</script>
<script src="js/jquery-1.11.2.min.js"></script>
<script type="text/javascript" src="jquery/jquery-ui.js"></script>
<script type="text/javascript" src="js/interface.js"></script>
<!--[if lt IE 7]>
 <style type="text/css">
 .dock img { behavior: url(iepngfix.htc) }
 </style>
<![endif]-->

<link href="css/menu.css" rel="stylesheet" type="text/css" />
<link href="css/geral.css" rel="stylesheet" type="text/css" />
<script>
$(function() {
    var availableTags = [
      "Campinas ",
      "Jundiaí"
      
    ];
    $( "#tags" ).autocomplete({
      source: availableTags
    });
  });
  
function SalvaLaboratorio(produtoID, servicoID, servicoprodutoID, obj, fase, prazo){
	$.post('sis_insere_laboratorio.jsp',  {lab: obj.value
										  ,produtoID: produtoID
										  ,servicoID: servicoID
										  ,servicoprodutoID: servicoprodutoID
										  ,fase: fase
										  ,prazo: prazo}
										  ,function(data){
												var lista = data.split("#");
											  	alert(lista[0].trim());
											  	location.reload();  	
										});
}

function confirmaFinalizacaoServico(servicoID){
	$.post('sis_finaliza_servico.jsp',  {servicoID: servicoID}
		  ,function(data){
			  	alert(data.trim());
			  	//location.reload();  	
		});
}

</script>
</head>

<body>

<div id="container">

<div id="topo">
 <jsp:include page="inc/menu_superior.jsp" />
</div>


<div id="corpo">
	<div id="conteudo" style="width: 100%; height: 600px;">
	  <div id="botoes" style="width: 100%; float: none;">	
		<%if(session.getAttribute("nivel").equals("2") || session.getAttribute("nivel").equals("1")){  %>
		
			<input type="button" class="botao" onclick="javascript: window.location.href='sis_insert_nova_os.jsp'" value=" + Nova OS" />&nbsp;
		
			<input type="button" class="botao" onclick="javascript: window.location.href='sis_servicos_fechados.jsp'" value="OS's Fechados" />
	  </div>
	  <div id="botoes" style="width: 100%; float: none;">
				<form name="formBuscaTodos" method="post">
				   	<input type="checkbox" name="todos" onclick="this.form.submit();" value="buscarTodas"  />
				   	<strong>Pesquisar Todas OS's Ativas</strong>
				 </form>
				<form name="formBuscaTodosOrcamentos" method="post">
					<input type="checkbox" name="todosOrcamentos" onclick="this.form.submit();" value="buscarTodasOrcamentos"  />
					<strong>Pesquisar Todos Orçamentos</strong>
				</form>
			
			<%} %>
			<%if(session.getAttribute("nivel").equals("7")){  %>
			
				<input type="button" class="botao" onclick="javascript: window.location.href='sis_insert_novo_orcamento.jsp?orcamento=1'" value=" + Novo Orçamento" />&nbsp;
			
			<%} %>
		</div>
			<div id="OS">
			<%while(rs.next())
			{
				if(!rs.getString("fim").equals("S")){
				%>
			
			<div style="border-radius: 25px;
			    border: 2px solid #8AC007;
			    padding: 20px; ">
				<div id="<%=rs.getString("servicoID") %>" onclick="exibe_esconde(this)" >
					<table align="center" cellpadding="5px">
						<tr bgcolor="#EEEEEE">
							<td>
							</td>
							<td>
								<strong>N&deg; O.S.</strong>
							</td>
							<td>
								<strong>Cliente</strong>
							</td>
							<td>
								<strong>Data Inicio</strong>
							</td>
							<td>
								<strong>Data Prevista</strong>
							</td>
							<%if(nivel.equals("1") || nivel.equals("2")) {%>
							<td>
								<strong>Valor</strong>
							</td>
							<%} %>
							<td>
								<strong>Editar</strong>
							</td>
							<td>
							</td>
						</tr>
						<tr>
							<td>
								<img src="images/delete.png" width="15" height="15" title="Excluir OS: <%=rs.getString("OS")+"/"+rs.getString("anoServico").substring(0,4) %>" 
									onclick="excluir(<%=rs.getString("OS")%>, <%=rs.getString("anoServico").substring(0,4)%>)"/>
							</td>
							<td >
								<strong><%=rs.getString("OS")+"/"+rs.getString("anoServico").substring(0,4) %></strong>
							</td>
							<td style="min-width: 300px; max-width: 400px;">
								<strong><%=rs.getString("clienteNomeFantasia") %></strong>
							</td>
							<td>
								<strong><%=data.converteDeData(rs.getString("dataInicio")) %></strong>
							</td>
							<td>
							<strong>
								<%if(!rs.getString("dataprevista1").equals("0")){%>
    								<%=data.converteDeData(rs.getString("dataprevista1")) %>
    							<%}
    							else
    							{%>
    								
    							<%}%>
    							</strong>
							</td>
							<%if(nivel.equals("1") || nivel.equals("2")){ %>
							<td style="min-width: 100px; text-align: left;">
								<strong><%=formato.format(rs.getDouble("valor")) %></strong>
							</td>
							<%} %>
							<%if(nivel.equals("1") || nivel.equals("2")) {%>
							<td>
								<a href="sis_update_os.jsp?servicoID=<%=rs.getString("servicoID") %>"><strong><img src="ico/ico_editar.png" width="20" height="20" border="0" title="Editar Serviço" /></strong></a>
							</td>
							<td>
								<a href="sis_print_cupom_servico_cliente.jsp?servicoID=<%=rs.getString("servicoID")%>&OS=<%=rs.getString("OS")%>&Ano=<%=rs.getString("anoServico").substring(0,4)%>"><img src="ico/ico_print.png" height="20" border="0" title="Imprimir O.S." /></a>
							</td>
							<td><a href="javascript: confirmaFinalizacaoServico(<%=rs.getString("servicoID")%>)"><img src="ico/ico_cofirmar.gif" width="20" height="20" border="0" title="Clique aqui para confirmar Finalizacao"/></a></td>
							<%}else{ %>
								<td>
								<a href="#"><strong><img src="ico/ico_editar.png" width="20" height="20" border="0" title="Editar Serviço" /></strong></a>
							</td>
							<td>
								<a href="#"><img src="ico/ico_print.png" height="20" border="0" title="Imprimir O.S." /></a>
							</td>
							<%} %>
						</tr>
						 <tr>
    						<td colspan="9" align="center" style="height:1px"><hr style="border:1px solid #333333" /></td>
   						</tr>
					</table>
				</div>
				<div id="detalhes<%=rs.getString("servicoID") %>" style="visibility: hidden; display: none;">
				<table align="center" cellpadding="5px">
				<%
				String Consulta = "";
				Consulta +="SELECT *, uv.usuarioNome as UsuarioVisualizador, u.usuarioNome as NomeResp, uf.usuarioNome as UsuarioFinalizador, ";
				Consulta +="case sp.dataRealRetorno  when '0000-00-00' then \"0\"";
				Consulta +=" else sp.dataRealRetorno ";
				Consulta +=" end as DataReal, ";
				Consulta +="case sp.dataPrevistaRetorno  when '0000-00-00' then \"0\"";
				Consulta +=" else sp.dataPrevistaRetorno ";
				Consulta +=" end as DataPrevista, ";
				Consulta +="case sp.dataEnvio  when '0000-00-00' then \"0\"";
				Consulta +=" else sp.dataEnvio ";
				Consulta +=" end as DataEnvio1 ";
				Consulta +=" FROM `servicoproduto` as sp ";		
				Consulta +=" left join produto as p on sp.produtoID = p.produtoID ";
				Consulta +=" left join usuario as u on sp.usuarioID = u.usuarioID ";
				Consulta +=" left join usuario as uv on sp.usuarioVisualizadoID = uv.usuarioID  ";
				Consulta +=" left join usuario as uf on sp.usuarioFinalizadorID = uf.usuarioID  ";
				Consulta +=" where servicoID = "+ rs.getString("servicoID");
				Consulta +=" and servicoFinalizado <> 1";
				if(nivel.equals("3")){
					Consulta += " and sp.fase in ('inicio', 'Env. Lab.', 'Reenv. Lab.', 'Ret. Prod.', 'Ed. Arte', 'Conferencia', 'Conferido')  ";
				}
				if(nivel.equals("4")){
					Consulta += " and sp.fase in ('Agd. Prd.', 'Prod.')  ";
				}
				
				
				rs11 = st11.executeQuery(Consulta);
				while(rs11.next()){	
				if(rs11.getInt("rotina") == 0){%>
				<tr>	
					<table align="center">
					 	<tr bgcolor="#EEEEEE" align="center">
					 		<td><strong>Nome</strong></td>
					 		<td><strong>Qtd</strong></td>
					 		<%if(nivel.equals("1") || nivel.equals("2")) {%>
					 		<td><strong>Valor</strong></td>
					 		<%} %>
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
					 		<%if(nivel.equals("1") || nivel.equals("2")) {%>
					 		<td><%=formato.format(rs11.getFloat("valor")) %></td>
					 		<%} %>
					 		<td><%=rs11.getString("qtdProduto") %></td>
					 		<%if(!rs11.getString("laboratorio").equals("Digite")){ %>
					 			<td style="max-width: 90px;"><input type="text" id="tags" style="max-width: 90px;" value="<%=rs11.getString("laboratorio") %>" onblur="SalvaLaboratorio(<%=rs11.getString("produtoID") %>, <%=rs.getString("servicoID")%>, <%=rs11.getString("servicoprodutoID")%>, this, '<%=rs11.getString("fase")%>', <%=rs11.getString("prazo")%>)"/></td>					 			
					 		<%}else{ %>
								<td style="max-width: 90px;"><input type="text" style="max-width: 90px;" name="laboratorio" id="tags" placeholder="Digite" onblur="SalvaLaboratorio(<%=rs11.getString("produtoID") %>, <%=rs.getString("servicoID")%>, <%=rs11.getString("servicoprodutoID")%>, this, '<%=rs11.getString("fase")%>', <%=rs11.getString("prazo")%>)"/></td>					 			
					 		<%} %>
					 		<%if(!rs11.getString("DataEnvio1").equals("0")){ %>
					 			<td><input type="date" name="dataEnvio" id="de<%=rs11.getString("servicoprodutoID") %>" value="<%=rs11.getString("DataEnvio1") %>" readonly="readonly" /></td>
					 		<%}else{ %>
								<td><input type="date" name="dataEnvio" id="de<%=rs11.getString("servicoprodutoID") %>" readonly="readonly"/></td>					 			
					 		<%} %>				 		
					 	<%if(!rs11.getString("DataEnvio1").equals("0")){ %>
					 		<%if(!rs11.getString("DataPrevista").equals("0")){%>
					 			<td><input type="date" name="dataPrevistaRetorno" id="dpr<%=rs11.getString("servicoprodutoID") %>" value="<%=rs11.getString("DataPrevista") %>" onchange="insereData (<%=rs11.getString("produtoID") %>, <%=rs.getString("servicoID")%>, <%=rs11.getString("servicoprodutoID")%>, this, 0)"/></td>
					 		<%}else{ %>
								<td><input type="date" name="dataPrevistaRetorno" id="dpr<%=rs11.getString("servicoprodutoID") %>"/></td>					 			
					 		<%}
					 		}else{%>
					 			<td><input type="date" name="dataPrevistaRetorno" id="dpr<%=rs11.getString("servicoprodutoID") %>" readonly="readonly"/></td>
					 		<%}%>
					 		<%if(!rs11.getString("DataReal").equals("0")){ %>
					 			<td><input type="date" name="dataRealRetorno" id="drr<%=rs11.getString("servicoprodutoID") %>" value="<%=rs11.getString("DataReal") %>" onchange="insereData (<%=rs11.getString("produtoID") %>, <%=rs.getString("servicoID")%>, <%=rs11.getString("servicoprodutoID")%>, this, 1)" /></td>
					 		<%}else{ %>
								<td><input type="date" name="dataRealRetorno" id="drr<%=rs11.getString("servicoprodutoID") %>" onchange="insereData (<%=rs11.getString("produtoID") %>, <%=rs.getString("servicoID")%>, <%=rs11.getString("servicoprodutoID")%>, this, 1)"/></td>					 			
					 		<%} %>
					 		<%if(!rs11.getString("fase").equals("inicio")){ %>
					 			<td><a href="#" title="<%=rs11.getString("NomeResp") + "\n" + rs11.getString("obsfase") %>" onclick="reenvia(<%=rs11.getString("produtoID") %>, <%=rs11.getString("servicoID") %>, <%=rs11.getString("servicoprodutoID") %>,'<%=rs11.getString("fase")%>', <%=rs11.getString("prazo")%>, <%=rs.getString("OS")%>, <%=rs.getString("anoServico").substring(0,4)%>)"><%=rs11.getString("fase") %></a></td>
					 		<%}else{ %>
					 			<td><%=rs11.getString("fase") %></td>
					 		<%} %>
					 		<td><%=rs11.getString("infos") %></td>
					 		<%if(rs11.getInt("visualizado") != 1){ %>
					 			<td><a href="javascript: confirma(<%=rs11.getString("produtoID") %>, <%=rs11.getString("servicoID")%>, <%=rs11.getString("servicoprodutoID") %>,'<%=rs11.getString("fase")%>', <%=rs11.getString("rotina")%>)"><img src="ico/ico_visualizar.png" width="20" height="20" border="0" title="Informar Início do Serviço" /> </a></td>
					 		<%}else{%>
					 				<td><a href="#"><img src="ico/ico_joinha.png" width="20" height="20" border="0" title="Serviço Iniciado Por: <%=rs11.getString("UsuarioVisualizador") %>" /> </a></td>
					 		<%} %>
					 	<%if(rs11.getInt("Finalizado") == 0) {%>
					 		<%if(rs11.getInt("visualizado") == 1){ %>
					 			<%if(!rs11.getString("DataReal").equals("0")) {%>
					 				<td><a href="javascript: confirmaFinalizacao(<%=rs11.getString("produtoID") %>
					 			, <%=rs11.getString("servicoID")%>
					 			, <%=rs11.getString("servicoprodutoID") %>
					 			,'<%=rs11.getString("fase")%>'
					 			,<%=rs11.getString("rotina")%>)"><img src="ico/ico_cofirmar.gif" width="20" height="20" border="0" title="Clique aqui para confirmar Finalizacao"/></a></td>
								<%}else{ %>
									<td><img src="ico/ico_cofirmar.gif" width="20" height="20" border="0" title="Informe data real de retorno para poder Finalizar!"/></td>
								<%} %>					 			
					 		<% }else{%>
					 				<td><img src="ico/ico_cofirmar.gif" width="20" height="20" border="0" title="Necessário Iniciar o Serviço Para Finaliza-lo!"/></td>
					 		<%}
					 		}else{ %>
					 			<td><img src="ico/ico_cofirmar.gif" width="20" height="20" border="0" title="Finalizado Por: <%=rs11.getString("UsuarioFinalizador") %>"/></td>
					 		<%}	%>
					 		
					 		
					 	</tr>
					 	<tr>
    						<td colspan="12" align="center" style="height:1px"><hr style="border:1px solid #333333" /></td>
   						</tr>
   					</table>
   					</tr>	
					<%
					}
					if(rs11.getInt("rotina") == 1){%>
					<tr>
					<table align="center">
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
				 		<%if(rs11.getInt("visualizado") != 1){ %>
					 			<td><a href="javascript: confirma(
					 			<%=rs11.getString("produtoID") %>
					 			, <%=rs11.getString("servicoID")%>
					 			, <%=rs11.getString("servicoprodutoID") %>
					 			,'<%=rs11.getString("fase")%>'
					 			,<%=rs11.getString("rotina")%>)" ><img src="ico/ico_visualizar.png" width="20" height="20" border="0" title="Informar Início do Serviço" /> </a></td>
					 		<%}else{%>
					 				<td><a href="#"><img src="ico/ico_joinha.png" width="20" height="20" border="0" title="Serviço Iniciado Por: <%=rs11.getString("UsuarioVisualizador") %>" /> </a></td>
					 		<%} %>
					 		<%if(rs11.getInt("Finalizado") == 0) {%>
					 		<%if(rs11.getInt("visualizado") == 1){ %>
					 				<td><a href="javascript: confirmaFinalizacao(<%=rs11.getString("produtoID") %>
					 			, <%=rs11.getString("servicoID")%>
					 			, <%=rs11.getString("servicoprodutoID") %>
					 			,'<%=rs11.getString("fase")%>'
					 			,<%=rs11.getString("rotina")%>)"><img src="ico/ico_cofirmar.gif" width="20" height="20" border="0" title="Clique aqui para confirmar Finalizacao"/></a></td>

					 		<% }else{%>
					 				<td><img src="ico/ico_cofirmar.gif" width="20" height="20" border="0" title="Necessário Iniciar o Serviço Para Finaliza-lo!"/></td>
					 		<%}
					 		}else{ %>
					 			<td><img src="ico/ico_cofirmar.gif" width="20" height="20" border="0" title="Finalizado Por: <%=rs11.getString("UsuarioFinalizador") %>"/></td>
					 		<%}
					 		%>
				 	</tr>
				 	<tr>
						<td colspan="12" align="center" style="height:1px"><hr style="border:1px solid #333333" /></td>
					</tr>
					</table>
					</tr>
					<%
					
					}
				}
				%>
				</table>
				</div>
			</div>	<%
			}
		}
			%>
			</div>
	<div id="rodape"><jsp:include page="inc/rodape.jsp" /></div>	
	</div>
	
</div>

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
			
		});

</script>

</body>
</html>