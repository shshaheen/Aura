import 'package:flutter/material.dart';

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
            DrawerHeader(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.onPrimaryContainer,
                    Theme.of(context).colorScheme.onPrimaryContainer.withAlpha((0.8*255).toInt(),
                    ),
                    ],
                    begin: Alignment.topLeft ,
                    end: Alignment.bottomRight,
                ),
                    ),
                child: Row(
                  children: [
                    Icon(
                      Icons.fastfood, 
                      size: 48, 
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    const SizedBox(width: 18,),
                    Text(
                      "Cooking Up!", 
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primaryContainer
                    ),)
      
                  ],
                ), ),
                ListTile(
                  leading: Icon(
                    Icons.restaurant, 
                    size: 26, 
                    color: Theme.of(context).colorScheme.onSurface,
                    ),
                  title: Text(
                    'Meals',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 24,
                  ),
                  ),
                  onTap: (){
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings, 
                  size: 26, 
                  color: Theme.of(context).colorScheme.onSurface,
                  ),
                  title: Text(
                    'Filters',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 24,
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
