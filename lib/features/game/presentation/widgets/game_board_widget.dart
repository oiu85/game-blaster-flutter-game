import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/game_tile.dart';
import 'game_tile_widget.dart';

class GameBoardWidget extends StatelessWidget {
  final List<List<GameTile>> board;
  final Function(GameTile) onTileTap;

  const GameBoardWidget({
    super.key,
    required this.board,
    required this.onTileTap,
  });

  @override
  Widget build(BuildContext context) {
    if (board.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20.r,
            spreadRadius: 5.r,
          ),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: board[0].length,
          crossAxisSpacing: 4.w,
          mainAxisSpacing: 4.h,
          childAspectRatio: 1.0,
        ),
        itemCount: board.length * board[0].length,
        itemBuilder: (context, index) {
          final row = index ~/ board[0].length;
          final col = index % board[0].length;
          final tile = board[row][col];

          return GameTileWidget(
            tile: tile,
            onTap: () => onTileTap(tile),
          );
        },
      ),
    );
  }
}

