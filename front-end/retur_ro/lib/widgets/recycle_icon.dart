import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecycleIcon extends StatelessWidget {
  final double? size;
  final Color? color;

  const RecycleIcon({
    super.key,
    this.size = 24.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/recycle-svgrepo-com.svg',
      width: size,
      height: size,
      colorFilter: color != null 
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
} 