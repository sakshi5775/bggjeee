import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainBannerWidget extends StatelessWidget {
  const MainBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        image: const DecorationImage(
          image: AssetImage(AppConstant.eMandirGanesha),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          /// TOP CONTROLS
          Positioned(
            top: 10,
            right: 10,
            child: Row(
              children: [
                _CircleIcon(Icons.volume_up),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    Get.toNamed(AppRoutes.virtualDarshan);
                  },
                  child: _CircleIcon(Icons.fullscreen),
                ),
              ],
            ),
          ),

          /// STORY AVATARS
          Positioned(
            top: 60,
            left: 12,
            right: 12,
            child: SizedBox(
              height: 50,
              child: Row(
                children: [
                  Container(
                    height: 50,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(
                            AppConstant.eMandirGanesha,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: AutoTranslateText(
                            "Shri Ganesh",
                            style: MyTextTheme.mediumBCN.copyWith(
                              color: Colors.orange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.orange, Colors.deepOrange],
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(AppConstant.eMandirPlusIcon),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 15,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Colors.orange, Colors.deepOrange],
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(
                              AppConstant.eMandirGodIcon,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// FLOWER BUTTON
          Positioned(
            bottom: 90,
            left: 18,
            child: Image.asset(AppConstant.eMandirAartiIcon),
          ),
          Positioned(
            bottom: 22,
            left: 18,
            child: Image.asset(AppConstant.eMandirLadduIcon),
          ),

          /// MUSIC BUTTON
          Positioned(
            bottom: 90,
            right: 18,
            child: Image.asset(AppConstant.eMandirAartiIcon),
          ),
          Positioned(
            bottom: 22,
            right: 18,
            child: InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.devotionalLibrary);
              },
              child: Image.asset(
                AppConstant.eMandirListenNowIcon,
                width: 50,
                height: 50,
              ),
            ),
          ),

          /// LISTEN NOW TEXT
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                child: AutoTranslateText(
                  "Listen Now",
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final IconData icon;

  const _CircleIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 26),
    );
  }
}
