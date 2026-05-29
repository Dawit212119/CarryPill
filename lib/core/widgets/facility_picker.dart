import 'package:carrypill/business_logic/provider/provider_location.dart';
import 'package:carrypill/constants/constant_color.dart';
import 'package:carrypill/core/utils/facility_utils.dart';
import 'package:carrypill/core/widgets/app_loading_indicator.dart';
import 'package:carrypill/data/models/facility.dart';
import 'package:carrypill/data/models/geo_point.dart';
import 'package:carrypill/data/models/patient.dart';
import 'package:carrypill/data/repositories/supabase_repo/database_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class FacilityPicker extends StatefulWidget {
  final Facility? selected;
  final Patient? patient;
  final ValueChanged<Facility?> onSelected;

  const FacilityPicker({
    super.key,
    required this.selected,
    required this.onSelected,
    this.patient,
  });

  @override
  State<FacilityPicker> createState() => _FacilityPickerState();
}

class _FacilityPickerState extends State<FacilityPicker> {
  final _searchController = TextEditingController();
  String _query = '';
  List<FacilityWithDistance>? _all;

  GeoPoint? get _origin {
    if (widget.patient?.geoPoint != null) return widget.patient!.geoPoint;
    final pos = Provider.of<ProviderLocation>(context, listen: false).position;
    if (pos != null) return GeoPoint(pos.latitude, pos.longitude);
    return null;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Facility>>(
      future: DatabaseRepo().facilityList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(height: 120.h, child: const AppLoadingIndicator(size: 40));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text(
            'No facilities found. Add one in Supabase healthcare_facilities.',
            style: TextStyle(fontSize: 13.sp, color: kctextgrey),
          );
        }

        _all ??= FacilityUtils.sortByDistance(snapshot.data!, _origin);
        final filtered = FacilityUtils.filterByQuery(_all!, _query);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search hospital or clinic…',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: kcWhite,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
            if (_origin != null) ...[
              SizedBox(height: 6.h),
              Text(
                'Sorted by distance from you',
                style: TextStyle(fontSize: 11.sp, color: kcGreyLabel),
              ),
            ],
            SizedBox(height: 8.h),
            ...filtered.map((item) {
              final f = item.facility;
              final selected = widget.selected?.documentID == f.documentID;
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Material(
                  color: selected ? kcPrimary.withValues(alpha: 0.08) : kcWhite,
                  borderRadius: BorderRadius.circular(10.r),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10.r),
                    onTap: () => widget.onSelected(f),
                    child: Ink(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: selected ? kcPrimary : kcDivider,
                          width: selected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            selected ? Icons.radio_button_checked : Icons.radio_button_off,
                            color: selected ? kcPrimary : kcGreyLabel,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  f.facilityName,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: kctextDark,
                                  ),
                                ),
                                Text(
                                  f.fullAddress,
                                  style: TextStyle(fontSize: 11.sp, color: kctextgrey),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          if (item.distanceKm != null)
                            Text(
                              '${item.distanceKm!.toStringAsFixed(1)} km',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: kcOrange,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            if (widget.selected == null)
              Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Text(
                  '(Required)',
                  style: TextStyle(fontSize: 10.sp, color: Colors.red, fontWeight: FontWeight.w600),
                ),
              ),
          ],
        );
      },
    );
  }
}
