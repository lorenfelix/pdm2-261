// 14-agregacao.dart
// Agregação e Composição

import 'dart:convert';

class Dependente {
  late String _nome;

  Dependente(String nome) {
    _nome = nome;
  }

  Map<String, dynamic> toJson() {
    return {
      "nome": _nome,
    };
  }
}

class Funcionario {
  late String _nome;
  late List<Dependente> _dependentes;

  Funcionario(String nome, List<Dependente> dependentes) {
    _nome = nome;
    _dependentes = dependentes;
  }

  Map<String, dynamic> toJson() {
    return {
      "nome": _nome,
      "dependentes": _dependentes,
    };
  }
}

class EquipeProjeto {
  late String _nomeProjeto;
  late List<Funcionario> _funcionarios;

  EquipeProjeto(String nomeProjeto, List<Funcionario> funcionarios) {
    _nomeProjeto = nomeProjeto;
    _funcionarios = funcionarios;
  }

  Map<String, dynamic> toJson() {
    return {
      "nomeProjeto": _nomeProjeto,
      "funcionarios": _funcionarios,
    };
  }
}

void main() {

  // 1. Criar objetos Dependente
  Dependente dep1 = Dependente("Ana");
  Dependente dep2 = Dependente("Carlos");
  Dependente dep3 = Dependente("Julia");
  Dependente dep4 = Dependente("Pedro");

  // 2 e 3. Criar Funcionarios e associar dependentes
  Funcionario func1 = Funcionario(
    "João",
    [dep1, dep2],
  );

  Funcionario func2 = Funcionario(
    "Maria",
    [dep3],
  );

  Funcionario func3 = Funcionario(
    "Lucas",
    [dep4],
  );

  // 4. Criar lista de funcionários
  List<Funcionario> funcionarios = [
    func1,
    func2,
    func3
  ];

  // 5. Criar equipe do projeto
  EquipeProjeto equipe = EquipeProjeto(
    "Sistema de Gestão Escolar",
    funcionarios,
  );

  // 6. Printar em JSON
  String jsonEquipe = JsonEncoder.withIndent("  ").convert(equipe);

  print(jsonEquipe);
}