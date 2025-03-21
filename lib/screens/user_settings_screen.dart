import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  static const String userNameKey = 'username';
  static const String countryKey = 'country';
  static const String userAgeKey = 'age';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  String countryEmoji = '';
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Perfil de Viajante")),
      body: _buildUserSettingScreenBody(),
    );
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString(userNameKey) ?? "";
      _ageController.text = prefs.getInt(userAgeKey)?.toString() ?? "";
      _countryController.text = prefs.getString(countryKey) ?? "";
      countryEmoji = _getCountryEmoji(_countryController.text);
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Dados Carregados com Sucesso!')));
  }

  void _saveUserData() async {
    String name = _nameController.text;
    String country = _countryController.text;
    int age = int.tryParse(_ageController.text) ?? 0;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(userNameKey, name);
    await prefs.setString(countryKey, country);
    await prefs.setInt(userAgeKey, age);

    setState(() {
      countryEmoji = _getCountryEmoji(country); // Atualiza o emoji após salvar
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Dados Salvos com Sucesso!")));
  }

  void _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userNameKey);
    await prefs.remove(countryKey);
    await prefs.remove(userAgeKey);

    setState(() {
      _nameController.clear();
      _ageController.clear();
      _countryController.clear();
      countryEmoji = ''; // Limpa o emoji
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Dados Limpos com Sucesso!")));
  }

  // Função para obter o emoji do país
  String _getCountryEmoji(String country) {
    switch (country.toLowerCase()) {
      case 'brazil':
        return '🇧🇷';
      case 'usa':
        return '🇺🇸';
      case 'france':
        return '🇫🇷';
      case 'japan':
        return '🇯🇵';
      case 'United States':
        return '🇺🇸';
      default:
        return '🌍'; // Emoji genérico para países desconhecidos
    }
  }

  _buildUserSettingScreenBody() {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(labelText: 'Name:'),
        ),
        TextField(
          controller: _ageController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Age:'),
        ),
        TextField(
          controller: _countryController,
          decoration: InputDecoration(labelText: 'Country:'),
        ),

        SizedBox(height: 30),

        if (countryEmoji.isNotEmpty)
          Text('País favorito: $countryEmoji', style: TextStyle(fontSize: 24)),

        SizedBox(height: 30),

        Row(
          mainAxisAlignment:
              MainAxisAlignment
                  .spaceEvenly, // vai posicionar os botões de forma centralizada e separado

          children: [
            ElevatedButton(onPressed: _saveUserData, child: Text('Salvar')),
            ElevatedButton(onPressed: _loadUserData, child: Text('Carregar')),
            ElevatedButton(onPressed: _clearUserData, child: Text('Limpar')),
          ],
        ),
      ],
    );
  }
}
