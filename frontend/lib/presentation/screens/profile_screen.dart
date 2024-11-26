import 'package:flutter/material.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil del Usuario'),
        backgroundColor: Colors.yellow,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Parte superior del perfil
            Container(
              color: Colors.yellow,
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/profile.png'), // Imagen del usuario
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Nombre del Usuario',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Biografía breve del usuario.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Lista de libros publicados
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Libros Publicados',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 5, // Número de libros
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.book, color: Colors.yellow),
                          title: Text('Título del Libro $index'),
                          subtitle: Text('Descripción breve del libro.'),
                          onTap: () {
                            // Acción para abrir el libro
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// Widget para construir columnas de estadísticas
  Widget _buildStatColumn(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}