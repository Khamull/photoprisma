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

String idUsu = (String) session.getAttribute("usuarioID");//recupera ID do usuário
%>

<%
//Instancia um objeto do tipo ResultSet para receber resultado de uma Consulta
ResultSet rs = null;
ResultSet rs01 = null;
ResultSet rs09 = null;
%>


<%
int dias = 0;
servico.empresa.empresaID = Integer.parseInt((String)session.getAttribute("empresaID"));
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

	/*if(session.getAttribute("nivel").equals("1"))
	{
		if(request.getParameter("todos") != null)
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
		
	}*/


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
</script>

<script type="text/javascript">

function confirma(servicoID, nivelUsuario, rotina){
	if(confirm("Deseja Confirmar a Início desse Serviço?")){
		window.location.href="sis_manager_confirmar_visualizacao.jsp?servicoID="+servicoID+"&nivelusuario="+nivelUsuario+"&rotina="+rotina;
	}
}

function naoConfirmado(){
	alert("Primeiro Viasualize o Servico para Encaminhar ou Finalizar");
		//window.location.href="sis_manager_confirmar_visualizacao.jsp?servicoID="+servicoID;
}

var fase = "";
function fase(passo)
{
	fase = passo;
}

//Encerra por fim a OS
function confirmaFinalizacao(servicoID, nivelUsuario, OS){
	
//		var caminho = document.getElementById("caminho");
	if(nivelUsuario == "7")
	{
		if(confirm("Encaminhar Nova OS?"))
		{
			window.open("sis_fecha_negocio.jsp?servicoID="+servicoID+"&nivelUsuario="+nivelUsuario+"&OS="+OS, "Nova OS", "width=480px, height=300px");
		}
	}
	else
	{
		if(confirm("Deseja Finalizar esta Etapa"))
		{
			//alert(caminho.value);
			window.location.href="sis_manager_confirmar_finalizacao.jsp?servicoID="+servicoID+"&nivelusuario="+nivelUsuario+"&fase="+fase;
		}
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

function agenda(servicoID, OS, ano, nivelUsuario)
{
	if(confirm("Agendar?"))
	{
		window.open("sis_agenda.jsp?servicoID="+servicoID+"&OS="+OS+"&ano="+ano+"&nivelUsuario="+nivelUsuario, "Agendar", "width=480px, height=300px");
	}
}

function excluir(OS, ANO)
{
	if(confirm("Deseja Realmente escluir a OS: "+OS+"/"+ANO))
	{
		window.location.href = "sis_permitir_exclusao_os.jsp?OS="+OS+"&ANO="+ANO;
	}
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

<link type="text/css" href="css/paging.css" rel="stylesheet" />	
<script type="text/javascript" src="js/paging.js"></script>

<link href="css/menu.css" rel="stylesheet" type="text/css" />
<link href="css/geral.css" rel="stylesheet" type="text/css" />
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
	  <div id="botoes" style="width: 100%; float: left;">
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

 </div>

 
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


	<script>
        var pager = new Pager('tb1', 12); 
        pager.init(); 
        pager.showPageNav('pager', 'pageNav'); 
        pager.showPage(1);
    </script>

</body>
</html>