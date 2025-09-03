import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:travelapp_frontend/generated/app_localizations.dart';

class PhotoDetailScreen extends StatelessWidget {
 final String imageUrl;
 final double latitude;
 final double longitude;
 final Function(Locale) onLocaleChange; // Novo parâmetro

 const PhotoDetailScreen({
   super.key,
   required this.imageUrl,
   required this.latitude,
   required this.longitude,
   required this.onLocaleChange, // Adicionado ao construtor
 });

 void _launchMaps(BuildContext context) async {
   try {
     print('[PhotoDetailScreen] Iniciando _launchMaps...');
     print('[PhotoDetailScreen] Coordenadas recebidas: lat=$latitude, lng=$longitude');
     
     // Verifica se as coordenadas são válidas
     if (latitude.isNaN || longitude.isNaN) {
       print('[PhotoDetailScreen] ERRO: Coordenadas inválidas - lat=$latitude, lng=$longitude');
       _showErrorDialog(context, 'Coordenadas inválidas');
       return;
     }
     
     // Lista de URLs para tentar em ordem de preferência
     final urlsToTry = [
      // 1. URL do Google Maps para visualizar (não navegar)
      'https://maps.google.com/?q=$latitude,$longitude',
      // 2. Geo URI padrão para visualização
      'geo:$latitude,$longitude?q=$latitude,$longitude',
      // 3. URL original do Google Maps
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
      // 4. URL de navegação (só se as outras falharem)
      'google.navigation:q=$latitude,$longitude',
    ];
     
     for (int i = 0; i < urlsToTry.length; i++) {
       final urlString = urlsToTry[i];
       print('[PhotoDetailScreen] Tentativa ${i + 1}: $urlString');
       
       try {
         final uri = Uri.parse(urlString);
         print('[PhotoDetailScreen] URI parseada: $uri');
         
         print('[PhotoDetailScreen] Verificando se pode abrir a URL...');
         final canLaunch = await canLaunchUrl(uri);
         print('[PhotoDetailScreen] canLaunchUrl resultado: $canLaunch');
         
         if (canLaunch) {
           print('[PhotoDetailScreen] URL pode ser aberta, tentando abrir...');
           
           final launchResult = await launchUrl(
             uri,
             mode: LaunchMode.externalApplication,
           );
           
           print('[PhotoDetailScreen] launchUrl resultado: $launchResult');
           
           if (launchResult) {
             print('[PhotoDetailScreen] Maps aberto com sucesso com URL ${i + 1}!');
             return; // Sucesso! Sair da função
           } else {
             print('[PhotoDetailScreen] launchUrl retornou false para URL ${i + 1}');
           }
         } else {
           print('[PhotoDetailScreen] canLaunchUrl retornou false para URL ${i + 1}');
         }
       } catch (e) {
         print('[PhotoDetailScreen] Erro na tentativa ${i + 1}: $e');
         continue; // Tentar próxima URL
       }
     }
     
     // Se chegou aqui, nenhuma URL funcionou
     print('[PhotoDetailScreen] Todas as URLs falharam');
     print('[PhotoDetailScreen] Coordenadas: lat=$latitude, lng=$longitude');
     _showErrorDialog(context, 'Não foi possível abrir o mapa. Verifique se você tem um aplicativo de mapas instalado.');
     
   } catch (e) {
     print('[PhotoDetailScreen] EXCEPTION FINAL em _launchMaps: $e');
     print('[PhotoDetailScreen] Coordenadas que causaram erro: lat=$latitude, lng=$longitude');
     _showErrorDialog(context, 'Erro ao tentar abrir o mapa');
   }
 }

 void _showErrorDialog(BuildContext context, String message) {
   showDialog(
     context: context,
     builder: (BuildContext context) {
       return AlertDialog(
         title: Text('Erro'),
         content: Text(message),
         actions: [
           TextButton(
             onPressed: () => Navigator.of(context).pop(),
             child: Text('OK'),
           ),
         ],
       );
     },
   );
 }

 @override
 Widget build(BuildContext context) {
   final takeMeThere = AppLocalizations.of(context)?.take_me_there ?? 'Take me there!';
   return Scaffold(
     backgroundColor: Colors.black,
     body: Stack(
       children: [
         Positioned.fill(
           child: Image.network(
             imageUrl,
             fit: BoxFit.cover,
           ),
         ),
         SafeArea(
           child: Align(
             alignment: Alignment.topLeft,
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: CircleAvatar(
                 backgroundColor: Colors.black.withOpacity(0.5),
                 child: IconButton(
                   icon: const Icon(Icons.arrow_back, color: Colors.white),
                   onPressed: () => Navigator.pop(context),
                 ),
               ),
             ),
           ),
         ),
         Align(
           alignment: Alignment.bottomCenter,
           child: Container(
             color: Colors.black.withOpacity(0.6),
             padding: const EdgeInsets.all(16.0),
             width: double.infinity,
             child: ElevatedButton(
               style: ElevatedButton.styleFrom(
                 backgroundColor: const Color(0xFFFE1F80),
                 padding: const EdgeInsets.symmetric(vertical: 16),
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(12),
                 ),
               ),
               onPressed: () => _launchMaps(context),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   Icon(Icons.location_pin, color: Colors.white),
                   SizedBox(width: 8),
                   Text(
                     takeMeThere,
                     style: TextStyle(
                       fontSize: 18,
                       color: Colors.white,
                     ),
                   ),
                 ],
               ),
             ),
           ),
         ),
       ],
     ),
   );
 }
}