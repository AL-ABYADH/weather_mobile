import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../controllers/weather_controller.dart';

class WeatherView extends StatelessWidget {
  WeatherView({super.key});
  final controller = Get.put(WeatherController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: RefreshConfiguration(
        headerBuilder: () => MaterialClassicHeader(
          backgroundColor: Theme.of(context).colorScheme.background,
          color: Theme.of(context).colorScheme.primary,
        ),
        child: SmartRefresher(
          onRefresh: () async {
            await controller.getData();
            controller.refreshController.refreshCompleted();
          },
          controller: controller.refreshController,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 140,
                collapsedHeight: 56,
                pinned: true,
                backgroundColor: Colors.black,
                elevation: 0,
                scrolledUnderElevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Weather',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  centerTitle: true,
                  titlePadding: const EdgeInsets.symmetric(vertical: 10),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/sky.jpg',
                        fit: BoxFit.cover,
                      ),
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(127, 0, 0, 0),
                              Color.fromARGB(255, 0, 0, 0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Obx(
                      () {
                        if (controller.currentState.value.isError) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(25),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'An error has occurred. Please check app permissions and internet connection.',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                    textAlign: TextAlign.center,
                                  ),
                                  IconButton(
                                    onPressed: () => controller.getData(),
                                    icon: const Icon(
                                      Icons.refresh,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        if (controller.currentState.value.isSuccess ||
                            controller.currentState.value.isLoading) {
                          return Padding(
                            padding: const EdgeInsets.all(15),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                color: Theme.of(context).colorScheme.background,
                              ),
                              child: controller.currentState.value.isLoading &&
                                      (controller.weather.value == null ||
                                          controller.position.value == null ||
                                          controller.address.value == null)
                                  ? CardLoading(
                                      height: 175,
                                      width: double.infinity,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      cardLoadingTheme: CardLoadingTheme(
                                        colorOne: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        colorTwo: Theme.of(context)
                                            .colorScheme
                                            .background
                                            .withRed(15)
                                            .withGreen(15)
                                            .withAlpha(15),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.location_on),
                                              const SizedBox(width: 8),
                                              Text(
                                                controller.address.value ??
                                                    'Unknown Location',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 3),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Text(
                                              DateFormat('EEE, MMMM d h:mm a')
                                                  .format(controller
                                                      .lastRefreshed.value!),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              216,
                                                              216,
                                                              216)),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            children: [
                                              Image.network(
                                                'http://openweathermap.org/img/w/${controller.weather.value!.weatherIcon!}.png',
                                                height: 70,
                                                width: 70,
                                              ),
                                              Text(
                                                '${controller.weather.value?.temperature?.celsius?.toStringAsFixed(0) ?? 'unknown'}°',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineLarge,
                                              ),
                                              const Spacer(),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    controller.weather.value
                                                            ?.weatherMain ??
                                                        'unknown',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                            color: const Color
                                                                .fromARGB(255,
                                                                216, 216, 216)),
                                                  ),
                                                  Text(
                                                    '${controller.weather.value?.tempMax?.celsius?.toStringAsFixed(0)}°/${controller.weather.value?.tempMin?.celsius?.toStringAsFixed(0)}°',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                            color: const Color
                                                                .fromARGB(255,
                                                                216, 216, 216)),
                                                  ),
                                                  Text(
                                                    'Feels like ${controller.weather.value?.tempFeelsLike?.celsius?.toStringAsFixed(0)}°',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                            color: const Color
                                                                .fromARGB(255,
                                                                216, 216, 216)),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                    const SizedBox(
                      height: 470,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
