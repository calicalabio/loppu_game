# loppu_game

Loppu (2021-present) is a top-down 2D game with a focus on battling hundreds of enemies at a time with a large array of 'smart' weapons that operate themselves.

Project focuses:
- Object pooling optimisation to allow thousands of projectile and enemy/player entities to exist in the scene at the same time without lag
- A grid-based 'infinite scrolling' map which is space-efficient but seamless from the player perspective.
- 'Rogue-lite', i.e., most elements of gameplay are randomised and present the player with many choices so every session of gameplay is a new experience.

Progress so far:
- All base mechanics (player, enemies, weapons, levels, menus, save/load, gameplay loop) have been implemented and function correctly
- Base art assets have been designed and additional assets will scale easily

To-do:
- Implement more enemies, weapon/equipment types for greater diversity
- Create levels that the player can complete
- Fine-tune each level to have a specific number of enemies/types of enemies
- Add specific 'win conditions' for each level