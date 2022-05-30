import 'package:flutter/material.dart';

class tela_empresa extends StatefulWidget {
  const tela_empresa({Key? key}) : super(key: key);

  @override
  State<tela_empresa> createState() => _tela_empresaState();
}

class _tela_empresaState extends State<tela_empresa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          "Empresa"
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                      "images/detalhe_empresa.png"
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Sobre a Empresa",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black
                      ),
                      ),
                  )
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(top:16),
                  child: Text(
                    "Não tinha medo o tal João de Santo Cristo Era o que todos diziam quando ele se perdeuDeixou pra trás todo o marasmo da fazendaSó pra sentir no seu sangue o ódio que Jesus lhe deuQuando criança só pensava em ser bandidoAinda mais quando com um tiro de soldado o pai morreuEra o terror da sertania onde moravaE na escola até o professor com ele aprendeuIa pra igreja só pra roubar o dinheiroQue as velhinhas colocavam na caixinha do altarSentia mesmo que era mesmo diferenteSentia que aquilo ali não era o seu lugar Ele queria sair para ver o marE as coisas que ele via na televisãoJuntou dinheiro para poder viajarDe escolha própria, escolheu a solidãComia todas as menininhas da cidadeDe tanto brincar de médico, aos doze era professorAos quinze, foi mandado pro o reformatóriOnde aumentou seu ódio diante de tanto terrorNão entendia como a vida funcionavaDiscriminação por causa da sua classe e sua corFicou cansado de tentar achar respostaE comprou uma passagem, foi direto a SalvadorE lá chegando foi tomar um cafezinhoE encontrou um boiadeiro com quem foi falarE o boiadeiro tinha uma passagem e ia perder a viagemMas João foi lhe salvarDizia ele estou indo pra Brasília Neste país lugar melhor não há Tô precisando visitar a minha filha Eu fico aqui e você vai no meu lugar E João aceitou sua proposta E num ônibus entrou no Planalto Central Ele ficou bestificado com a cidade Saindo da rodoviária, viu as luzes de Natal Meu Deus, mas que cidade linda No Ano Novo eu começo a trabalhar Cortar madeira, aprendiz de carpinteiro Ganhava cem mil por mês em Taguatinga Na sexta-feira ia pra zona da cidade Gastar todo o seu dinheiro de rapaz trabalhador E conhecia muita gente interessante Até um neto bastardo do seu bisavô Um peruano que vivia na Bolívia E muitas coisas trazia de lá Seu nome era Pablo e ele dizia Que um negócio ele ia começar"
                ),
              )

            ],
          ),
        )
      )
    );
  }
}
