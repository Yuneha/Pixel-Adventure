import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/widgets/character_idle.dart';
import 'package:pixel_adventure/widgets/custom_button.dart';

class CharacterSelectionMenu extends StatefulWidget {
  static const List<String> characters = [
    'Mask Dude',
    'Ninja Frog',
    'Pink Man',
    'Virtual Guy',
  ];
  final PixelAdventure game;
  final void Function(String) onCharacterSelected;

  const CharacterSelectionMenu({
    super.key,
    required this.game,
    required this.onCharacterSelected,
  });

  @override
  State<CharacterSelectionMenu> createState() => _CharacterSelectionMenuState();
}

class _CharacterSelectionMenuState extends State<CharacterSelectionMenu> {
  late String selectedCharacter;

  @override
  void initState() {
    super.initState();
    selectedCharacter = CharacterSelectionMenu.characters.first;
    widget.onCharacterSelected(selectedCharacter);
  }

  void _onCharacterTap(String character) {
    setState(() {
      selectedCharacter = character;
    });
    widget.onCharacterSelected(character);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              // Main Content
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Select Your Character Skin',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Display Character (Idle Animation) And a selected box
                  _buildCharactersDisplay(),

                  const SizedBox(height: 40),

                  // Start Game Button
                  CustomButton(
                    text: 'Confirm',
                    onPressed: () {
                      widget.game.startGame();
                    },
                  ),
                ],
              ),
            ),

            // Back button at top left
            Positioned(
              top: 32,
              left: 32,
              child: IconButton(
                onPressed: () {
                  widget.game.playState = PlayState.mainMenu;
                },
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 64),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharactersDisplay() {
    return Wrap(
      spacing: 50,
      children:
          CharacterSelectionMenu.characters.map((character) {
            final isSelected = character == selectedCharacter;
            return GestureDetector(
              onTap: () => _onCharacterTap(character),
              child: Container(
                decoration: BoxDecoration(
                  border:
                      isSelected
                          ? Border.all(color: Colors.redAccent, width: 4)
                          : null,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow:
                      isSelected
                          ? [
                            BoxShadow(
                              color: Colors.redAccent.withValues(alpha: 0.6),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ]
                          : null,
                ),
                padding: const EdgeInsets.all(4),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: GameWidget(
                    game: CharacterIdleGame(characterName: character),
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
