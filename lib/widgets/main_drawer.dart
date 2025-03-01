import 'package:aura/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:aura/screens/phone_screen.dart';
class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});
  // final void Function(String identifier) onSelectScreen;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.70, // Reduce width to 75% of screen
      child: Drawer(
        child: Column(
          children: [
            SizedBox(
              height: 120,
              child: DrawerHeader(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.onPrimaryContainer.withAlpha((0.8*255).toInt(),
                      ),
                      ],
                      begin: Alignment.topLeft ,
                      end: Alignment.bottomRight,
                  ),
                      ),
                  child: InkWell(
                  onTap: () {
                    // print("Navigate to Profile Page");
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CompleteProfileScreen()));
                  },
                  borderRadius: BorderRadius.circular(12), // Smooth ripple effect
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0), // Better touch area
                    child: Row(
                      children: [
                        Icon(
                          Icons.account_circle,
                          size: 40,
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Profile",
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                color: Theme.of(context).colorScheme.primaryContainer,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                ),
            ),
                ListTile(
                  leading: Icon(
                    LucideIcons.stickyNote, 
                    size: 26, 
                    color: Theme.of(context).colorScheme.onSurface,
                    ),
                  title: Text(
                    'Feedback',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 20,
                  ),
                  ),
                  onTap: (){
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout_outlined, 
                  size: 26, 
                  color: Theme.of(context).colorScheme.onSurface,
                  ),
                  title: Text(
                    'Logout',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 20,
                  ),
                  ),
                  onTap: (){
                  },
                ),
          ],
        )
      ),
    );
  }
}
