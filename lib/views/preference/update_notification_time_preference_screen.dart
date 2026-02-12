import 'package:flutter/material.dart';
import 'package:motivational/extensions/media_query_extension.dart';
import 'package:motivational/extensions/size_box_extension.dart';
import 'package:motivational/providers/theme_provider.dart';
import 'package:motivational/services/api_service.dart';
import 'package:motivational/utils/icons.dart';
import 'package:motivational/views/auth/widget/auth_button.dart';
import 'package:motivational/views/widgets/custom_loader_center.dart';

import 'package:provider/provider.dart';
import 'package:time_range_picker/time_range_picker.dart';

import '../../app/my_app_view.dart';
import '../../model/quote_theme.dart';
import '../../providers/notification_time_preference_provider.dart';
import '../../utils/images.dart';
import '../../utils/my_colors.dart';
import '../home/setting/setting_screen.dart';
import '../quotegroups/widget/group_quote_theme_widget.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/icon_wrapper_body.dart';

class UpdateNotificationTimePreferenceScreen extends StatefulWidget {
  const UpdateNotificationTimePreferenceScreen({super.key});

  @override
  State<UpdateNotificationTimePreferenceScreen> createState() =>
      _UpdateNotificationTimePreferenceScreenState();
}

class _UpdateNotificationTimePreferenceScreenState
    extends State<UpdateNotificationTimePreferenceScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<NotificationTimePreferenceProvider>()
          .getPrefrenceForNotication();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationTimePreferenceProvider>();
    // final userProvider = context.read<UserProvider>();
    final QuoteTheme? theme = ApiService.userData?.quotetheme;
    return Scaffold(
      body: IconWrapperBody(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              50.vSpace(),
              const CustomBackButton(),
              30.vSpace(),
              const Text(
                'Preference.',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w600,
                  color: MyColors.blackTypeColor,
                ),
              ),
              12.vSpace(),
              const Text(
                // 'Select a theme to personalize your notifications. Your chosen theme will influence the content and style of the messages you receive.',
                'Select a theme to personalize your notifications. Want a different theme? Email Info@quickjesusreminder for a theme request.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: MyColors.colorE1E1,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      25.vSpace(),
                      GroupQuoteThemeWidgetNew(
                        asset: Images.quoteGroupSilver,
                        name: theme?.name ?? 'N/A',
                        description: theme?.description ?? 'N/A',
                      ),
                      20.vSpace(),
                      if (provider.getPreferenceLoading)
                        const CustomLoaderCenter()
                      // else if (provider.preference == null)
                      //   const NoDataWidget()
                      else ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Flexible(
                              child: Text(
                                'Choose QJR theme',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: MyColors.colorE1E1,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Consumer<ThemeProvider>(
                              builder: (context, value, child) {
                                return SizedBox(
                                  width: 50.percentWidth(),
                                  child: DropdownButtonFormField<int>(
                                    value: provider.selectedThemeId,
                                    hint: const  Text("Select Theme", style: TextStyle(fontSize: 15, color: Colors.black54),),
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            width: 1.5,
                                            color: MyColors.blackTypeColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),

                                        borderSide: const BorderSide(
                                            width: 1.5,
                                            color: MyColors
                                                .blackTypeColor), // Normal state border color
                                      ),
                                      // errorBorder: OutlineInputBorder(
                                      //   borderRadius: BorderRadius.circular(12),
                                      //   borderSide: const BorderSide(
                                      //       color:
                                      //           Colors.red), // Error state border color
                                      // ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12),
                                    ),
                                    items: value.quoteThemesList.map((val) {
                                      return DropdownMenuItem(
                                        value: val.id,
                                        child: SizedBox(
                                            width: 135,
                                            child: Text(
                                              val.name ?? '',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                      );
                                    }).toList(),
                                    onChanged: (val) =>
                                        provider.setSelectedThemeId(val!),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        22.vSpace(),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: MyColors.primaryColor.withOpacity(.5),
                            borderRadius: BorderRadius.circular(
                              16,
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.5,
                                      child: const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Notifications',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600,
                                              color: MyColors.blackTypeColor,
                                            ),
                                          ),
                                          Text(
                                            'Select notifications with your own time and date.',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: MyColors.blackTypeColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Image.asset(IconAssets.bell, height: 33)
                                  ],
                                ),
                                20.vSpace(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // _dailyButton(
                                    //   context,
                                    //   selectedTime: provider.selectedDailyTime,
                                    //   onTap: () async {
                                    //     final time = await showTimePicker(
                                    //       context: context,
                                    //       initialTime: TimeOfDay.now(),
                                    //     );
                                    //     if (time == null) {
                                    //       return;
                                    //     }
                                    //     provider.setDailyTime(time);
                                    //   },
                                    // ),
                                    // 10.hSpace(),
                                    // Text(
                                    //   "or",
                                    //   style: TextStyle(
                                    //     fontSize: 16.pxH(),
                                    //     fontWeight: FontWeight.w500,
                                    //     color: MyColors.blackTypeColor,
                                    //   ),
                                    // ),
                                    // 10.hSpace(),
                                    // _scheduleButton(
                                    //   context,
                                    //   onTap: () async {
                                    //     await showModalBottomSheet(
                                    //       context: context,
                                    //       builder: (context) => DayPicker(
                                    //         onTap: provider.onDaySelect,
                                    //         onSave: () async {
                                    //           MyApp.gState.pop();
                                    //           final time = await showTimePicker(
                                    //             context: context,
                                    //             initialTime: TimeOfDay.now(),
                                    //             confirmText: "Proceed",
                                    //           );
                                    //           if (time != null) {
                                    //             provider.setCustomTime(time);
                                    //           }
                                    //         },
                                    //       ),
                                    //     );
                                    //   },
                                    //   time: provider.selectedTime,
                                    // ),

                                    _dailyButton(
                                      context,
                                      selectedTime: provider.selectedDailyTime,
                                      selectedEndTime:
                                          provider.selectedDailyEndTime,
                                      onTap: () async {
                                        TimeOfDay? startTime;
                                        TimeOfDay? endTime;
                                        if (provider.selectedDailyTime ==
                                            null) {
                                          startTime = TimeOfDay.now();

                                          endTime = TimeOfDay(
                                              hour: (startTime.hour + 2) % 24,
                                              minute: startTime.minute);
                                        } else {
                                          startTime =
                                              provider.selectedDailyTime;
                                          endTime =
                                              provider.selectedDailyEndTime;
                                        }
                                        TimeRange? result =
                                            await showTimeRangePicker(
                                          use24HourFormat: false,
                                          start: startTime,
                                          end: endTime,
                                          barrierDismissible: false,
                                          ticks: 12,
                                          ticksColor: Colors.grey,
                                          ticksWidth: 3,
                                          clockRotation: 180,
                                          labels: [
                                            "12 am",
                                            "3 am",
                                            "6 am",
                                            "9 am",
                                            "12 pm",
                                            "3 pm",
                                            "6 pm",
                                            "9 pm"
                                          ].asMap().entries.map((e) {
                                            return ClockLabel.fromIndex(
                                                idx: e.key,
                                                length: 8,
                                                text: e.value);
                                          }).toList(),
                                          maxDuration:
                                              const Duration(hours: 24),
                                          minDuration: const Duration(hours: 1),
                                          autoAdjustLabels: true,
                                          rotateLabels: true,
                                          context: context,
                                        );
                                        if (result == null) {
                                          return;
                                        }
                                        provider.setDailyTime(result);
                                      },
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        left: 220.pxH(),
                                      ),
                                      child: Text(
                                        'or',
                                        style: TextStyle(
                                          fontSize: 15.pxH(),
                                          fontWeight: FontWeight.w600,
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                    30.vSpace(),
                                    _scheduleButton(
                                      context,
                                      onTap: () async {
                                        TimeOfDay? startTime;
                                        TimeOfDay? endTime;
                                        if (provider.selectedTime == null) {
                                          startTime = TimeOfDay.now();

                                          endTime = TimeOfDay(
                                              hour: (startTime.hour + 2) % 24,
                                              minute: startTime.minute);
                                        } else {
                                          startTime = provider.selectedTime;
                                          endTime = provider.selectedEndTime;
                                        }
                                        await showModalBottomSheet(
                                          context: context,
                                          builder: (context) => DayPicker(
                                            onTap: provider.onDaySelect,
                                            onSave: () async {
                                              MyApp.gState.pop();
                                              TimeRange? result =
                                                  await showTimeRangePicker(
                                                use24HourFormat: false,
                                                start: startTime,
                                                end: endTime,
                                                barrierDismissible: false,
                                                ticks: 12,
                                                ticksColor: Colors.grey,
                                                ticksWidth: 3,
                                                clockRotation: 180,
                                                labels: [
                                                  "12 am",
                                                  "3 am",
                                                  "6 am",
                                                  "9 am",
                                                  "12 pm",
                                                  "3 pm",
                                                  "6 pm",
                                                  "9 pm"
                                                ].asMap().entries.map((e) {
                                                  return ClockLabel.fromIndex(
                                                      idx: e.key,
                                                      length: 8,
                                                      text: e.value);
                                                }).toList(),
                                                maxDuration:
                                                    const Duration(hours: 24),
                                                minDuration:
                                                    const Duration(hours: 1),
                                                autoAdjustLabels: true,
                                                rotateLabels: true,
                                                context: context,
                                              );

                                              if (result != null) {
                                                provider.setCustomTime(result);
                                              }
                                            },
                                          ),
                                        );
                                      },
                                      time: provider.selectedTime,
                                      endTime: provider.selectedEndTime,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        30.vSpace(),
                        Align(
                          child: AuthButton(
                            loading: provider.loading,
                            text: 'Save Changes',
                            onPressed: () => provider.saveThemeAndTimePrefrence(
                              context
                                  .read<ThemeProvider>()
                                  .quoteThemesList
                                  .firstWhere((val) =>
                                      provider.selectedThemeId == val.id),
                            ),
                          ),
                        ),
                      ],
                      40.vSpace(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scheduleButton(
    BuildContext context, {
    required Function() onTap,
    required TimeOfDay? time,
    required TimeOfDay? endTime,
  }) {
    final provider = context.watch<NotificationTimePreferenceProvider>();
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -24,
          left: -4,
          child: Container(
            margin: const EdgeInsets.only(left: 4),
            width: 170.pxH(),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ).copyWith(bottom: 20, top: 6),
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              color: MyColors.yellowLightColor,
              borderRadius: BorderRadius.circular(120),
            ),
            child: const Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Days',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: MyColors.blackTypeColor,
                        ),
                      ),
                      Text(
                        'Time',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: MyColors.blackTypeColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        ),
        InkWell(
          onTap: onTap,
          child: Container(
            width: 200.pxH(),
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 19,
            ).copyWith(left: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: MyColors.blackTypeColor,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  // "Mo,Tu..",
                  provider.selectedDays.isEmpty
                      ? "--,--,--"
                      : provider.formatDays,
                  style: TextStyle(
                    fontSize: 15.pxH(),
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      time == null ? "---:---" : time.format(context),
                      style: TextStyle(
                        fontSize: 15.pxH(),
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                    ),
                    10.vSpace(),
                    Text(
                      endTime == null ? "---:---" : endTime.format(context),
                      style: TextStyle(
                        fontSize: 15.pxH(),
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                    ),
                  ],
                ),
                8.hSpace(),
                const CustomForwardIcon(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _dailyButton(
    BuildContext context, {
    required Function() onTap,
    required TimeOfDay? selectedTime,
    required TimeOfDay? selectedEndTime,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200.pxH(),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 19,
        ).copyWith(left: 20),
        decoration: BoxDecoration(
          border: Border.all(
            color: MyColors.blackTypeColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Daily',
              style: TextStyle(
                fontSize: 15.pxH(),
                fontWeight: FontWeight.w600,
                height: 1,
              ),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // if (selectedTime != null) ...[

                Text(
                  selectedTime == null ? "--:--" : selectedTime.format(context),
                  style: TextStyle(
                    fontSize: 15.pxH(),
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
                10.vSpace(),
                Text(
                  selectedEndTime == null
                      ? "--:--"
                      : selectedEndTime.format(context),
                  style: TextStyle(
                    fontSize: 15.pxH(),
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),

                // ],
              ],
            ),
            8.hSpace(),
            const CustomForwardIcon(),
          ],
        ),
      ),
    );
  }
}

class DayPicker extends StatelessWidget {
  final Function(String) onTap;
  final Function() onSave;
  const DayPicker({
    super.key,
    required this.onTap,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationTimePreferenceProvider>(
      builder: (context, value, child) {
        return Container(
          width: MediaQuery.sizeOf(context).width,
          padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.vSpace(),
              Text(
                "Select Days",
                style: TextStyle(
                  fontSize: 22.pxH(),
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
              ),
              22.vSpace(),
              Wrap(
                spacing: 15,
                runSpacing: 20,
                children: value.daysConst
                    .map(
                      (day) => GestureDetector(
                        onTap: () => onTap(day),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: MyColors.blackTypeColor,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            color: value.selectedDays.contains(day)
                                ? MyColors.primaryColor
                                : null,
                          ),
                          child: Text(
                            day,
                            style: TextStyle(
                              fontSize: 12.pxH(),
                              fontWeight: FontWeight.w600,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              40.vSpace(),
              AuthButton(
                text: "Save Changes",
                onPressed: onSave,
                // size: Size(MediaQuery.sizeOf(context).width, 40),
              ),
              40.vSpace(),
            ],
          ),
        );
      },
    );
  }
}
