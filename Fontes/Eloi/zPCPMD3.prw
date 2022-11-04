//Bibliotecas
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

//Variveis Estaticas
Static cTitulo := "Cadastro de Planejamento da Producao Beneficiamento"
Static cTabPai := "ZPE"
Static cTabFilho := "ZPF"
Static cTabFilho2 := "ZP9"

/*/
Cadastro customizado de Planejamento da Produção do Beneficiamento
@author Eloi
/*/

User Function zPCPMD3()
	Local aArea   := FWGetArea()
	Local oBrowse
	Private aRotina := {}

	//Definicao do menu
	aRotina := MenuDef()

	//Instanciando o browse
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias(cTabPai)
	oBrowse:SetDescription(cTitulo)
	oBrowse:DisableDetails()

	//Ativa a Browse
	oBrowse:Activate()

	FWRestArea(aArea)
Return Nil

Static Function MenuDef()
	Local aRotina := {}

	//Adicionando opcoes do menu
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.zPCPMD3" OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.zPCPMD3" OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.zPCPMD3" OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.zPCPMD3" OPERATION 5 ACCESS 0

Return aRotina

Static Function ModelDef()
	Local oStruPai := FWFormStruct(1, cTabPai)
	Local oStruFilho := FWFormStruct(1, cTabFilho)
    Local oStruFilho2 := FWFormStruct(1, cTabFilho2)
	Local aRelation := {}
	Local aRelation2 := {}
	Local oModel
	Local bPre := Nil
	Local bPos := Nil
	Local bCommit := Nil
	Local bCancel := Nil


	//Cria o modelo de dados para cadastro
	oModel := MPFormModel():New("zPCPMD3M", bPre, bPos, bCommit, bCancel)
	oModel:AddFields("ZPEMASTER", /*cOwner*/, oStruPai)
	oModel:AddGrid("ZPFDETAIL","ZPEMASTER",oStruFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	oModel:AddGrid("ZP9DETAIL","ZPEMASTER",oStruFilho2,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	oModel:SetDescription("Modelo de dados - " + cTitulo)
	oModel:GetModel("ZPEMASTER"):SetDescription( "Dados de - " + cTitulo)
	oModel:GetModel("ZPFDETAIL"):SetDescription( "Grid de - " + cTitulo)
	oModel:GetModel("ZP9DETAIL"):SetDescription( "Grid de - " + cTitulo)
	oModel:SetPrimaryKey({})

	//Fazendo o relacionamento
	aAdd(aRelation, {"ZPF_FILIAL", "FWxFilial('ZPF')"} )
	aAdd(aRelation, {"ZPF_DOCFB", "ZPE_DOCFB"})
	oModel:SetRelation("ZPFDETAIL", aRelation, ZPF->(IndexKey(1)))

	aAdd(aRelation2, {"ZP9_FILIAL", "FWxFilial('ZP9')"} )
	aAdd(aRelation2, {"ZP9_DOCBMB", "ZPE_DOCFB"})
	oModel:SetRelation("ZP9DETAIL", aRelation2, ZP9->(IndexKey(1)))

Return oModel

Static Function ViewDef()
	Local oModel := FWLoadModel("zPCPMD3")
	Local cCampoZPE := 'ZPE_DTFEC,ZPE_OP,ZPE_DTEXEC'
	Local cCampoZPF := 'ZPF_FILIAL, ZP9_DOCBMB, ZP9_FILBML, ZP9_DOCBML, ZP9_REALCE, ZP9_QTDLVR, ZP9_TEOR, ZP9_METAL, ZP9_REC, ZP9_QTDBNF'
	Local cCampoZP9:= 'ZP9_FILIAL, ZPF_DOCFB, ZPF_VER, ZPF_FILBML, ZPF_DOCBML, ZPF_REALCE, ZPF_QTBD01, ZPF_QTBD31'
	
	Local oStruPai := FWFormStruct(2, cTabPai , {|cCampo| .NOT. AllTrim(cCampo) $ cCampoZPE})
	Local oStruFilho := FWFormStruct(2, cTabFilho, {|cCampo1|  .NOT. AllTrim(cCampo1) $ cCampoZPF})
	Local oStruFilho2 := FWFormStruct(2, cTabFilho2, {|cCampo2| .NOT. AllTrim(cCampo2) $ cCampoZP9})
	Local oView

	//Cria a visualizacao do cadastro
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField("VIEW_ZPE", oStruPai, "ZPEMASTER")
	oView:AddGrid("VIEW_ZPF",  oStruFilho,  "ZPFDETAIL")
	oView:AddGrid("VIEW_ZP9",  oStruFilho2,  "ZP9DETAIL")

	//Partes da tela
	oView:CreateHorizontalBox("CABEC", 30)
	oView:CreateHorizontalBox("GRID", 70)

	oView:CreateFolder('PASTA_FILHOS', 'GRID')

	oView:AddSheet('PASTA_FILHOS', 'ABA_FILHO001', 'Budget Mensal Lavra (Lista Passiva de Planejamento do Beneficiamento)')
	oView:AddSheet('PASTA_FILHOS', 'ABA_FILHO002', 'Planejamento Producao')


	oView:CreateHorizontalBox('ITENS_FILHO01', 100,,, 'PASTA_FILHOS', 'ABA_FILHO001')
	oView:CreateHorizontalBox('ITENS_FILHO02', 100,,, 'PASTA_FILHOS', 'ABA_FILHO002')

	oView:SetOwnerView("VIEW_ZPE", "CABEC")
	oView:SetOwnerView("VIEW_ZPF", "ITENS_FILHO01")
    oView:SetOwnerView("VIEW_ZP9", "ITENS_FILHO02")





	//Adicionando campo incremental na grid
	oView:AddIncrementField("VIEW_ZPF", "ZPF_FILBML")

Return oView
