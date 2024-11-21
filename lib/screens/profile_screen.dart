import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Profile'),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner Image with overlapping CircleAvatar
            Stack(
              clipBehavior: Clip.none, // Prevents clipping of the CircleAvatar
              children: [
                // Banner Image
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/banner.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // CircleAvatar overlapping the banner
                Positioned(
                  top: 150, // Pushes the avatar on top of the banner
                  left: 0,
                  right: 0,
                  child: Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage('assets/images/profile.jpg'),
                      backgroundColor: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),

            // Padding to make space for the CircleAvatar
            const SizedBox(height: 80),

            // Name and ID
            Text(
              'Gabriel Marcellino Sinurat',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '22552011043',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.inversePrimary,
              ),
            ),

            // About Section
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Hi, izin memperkenalkan diri, saya Gabriel Marcellino Sinurat dengan NIM: 22552011043 dari kelas TIF RM - 22 CID. Membuat project aplikasi ini untuk memenuhi tugas Ujian Tengah Semester dari mata kuliah Pemrograman Mobile 2 yang diampu oleh Pak Dosen: Andri Nugraha Ramdhon, S.Kom., M.Kom. Sekian dari saya, atas perhatiannya saya ucapkan Terima Kasih!",
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
