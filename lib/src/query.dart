// ignore_for_file: unused_element, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

part of elastic_app_search;

/// An object containing all the settings to execute a query
///
/// See https://www.elastic.co/guide/en/app-search/current/search.html
/// to get more information about all the parameters.
///
/// Note: All the parameters of Elastic App Search are not currently
/// available in this package.
@freezed
class ElasticQuery with _$ElasticQuery {
  const ElasticQuery._();

  @JsonSerializable(
    explicitToJson: true,
    includeIfNull: false,
  )
  @Assert('engine != null', 'An engine is required to build a query.')
  @Assert(
      'precisionTuning == null || (precisionTuning != null && precisionTuning >= 1 && precisionTuning <= 11)',
      'The value of the precision parameter must be an integer between 1 and 11, inclusive.')
  const factory ElasticQuery({
    /// An object representing an Elastic engine
    @JsonKey(includeToJson: false, includeFromJson: false)
    ElasticEngine? engine,

    /// String or number to match.
    required String query,

    /// Use the precision parameter of the search API to tune precision
    /// and recall for a query. Learn more in Precision tuning (beta).
    /// See [https://www.elastic.co/guide/en/app-search/current/search-api-precision.html]
    ///
    /// The value of the precision parameter must be an integer between 1 and 11, inclusive.
    /// The range of values represents a sliding scale that manages the inherent tradeoff between precision and recall.
    /// Lower values favor recall, while higher values favor precision.
    @protected @JsonKey(name: "precision") int? precisionTuning,

    /// Object to delimit the pagination parameters.
    @JsonKey(name: "page") _ElasticSearchPage? searchPage,

    /// Object to filter documents that contain a specific field value.
    /// See [https://www.elastic.co/guide/en/app-search/current/filters.html]
    @_ElasticSearchFiltersConverter() List<_ElasticSearchFilter>? filters,

    /// Object which restricts a query to search only specific fields.
    @_ElasticSearchFieldsConverter()
    @JsonKey(name: "search_fields")
    List<_ElasticSearchField>? searchFields,

    /// Object to define the fields which appear in search results and how their values are rendered.
    @_ElasticResultFieldsConverter()
    @JsonKey(name: "result_fields")
    List<_ElasticResultField>? resultFields,

    /// Facets are objects which provide the counts of each value or range of values for a field.
    /// See [https://www.elastic.co/guide/en/app-search/current/facets.html]
    @protected Map<String, _ElasticQueryFacet>? facets,

    /// Disjunctive facets are useful when you have many filters in your form, and especially
    /// when you filter your query with a value that corresponds to a facet: if a disjunctive facet is set,
    /// it will return all the available facets as if that filter was not applied.
    /// This is not a native part of Elastic App Search, this is a workaround. In fact, multiple queries are
    /// passed to Elastic and the package concatenates all responses in one response.
    @JsonKey(includeToJson: false) List<String>? disjunctiveFacets,

    /// Tags can be used to enrich each query with unique information.
    /// See [https://www.elastic.co/guide/en/app-search/current/tags.html]
    _ElasticAnalytics? analytics,

    /// Grouped results based on shared fields
    @protected @JsonKey(name: "group") _ElasticGroup? groupBy,

    /// Object to sort your results in an order other than document score.
    @_ElasticSortConverter() @JsonKey(name: "sort") List<_ElasticSort>? sortBy,
  }) = _ElasticQuery;

  factory ElasticQuery.fromJson(Map<String, dynamic> json) =>
      _$ElasticQueryFromJson(json);

  /// Creates and returns a new [ElasticQuery] with additional [ElasticSearchFilter],
  /// an object to filter documents that contain a specific field value.
  /// Available on text, number, and date fields.
  ///
  /// Elastic filters can be of three types:
  /// * Value filters:
  /// - isEqualTo which will make a filter based on a value
  /// - whereIn which will make a filter based on an array of values
  ///
  /// * Range filters (works with `DateTime` and `double` types):
  /// - isGreaterThanOrEqualTo which is the inclusive lower bound of the range
  /// - isLessThan which is the exclusive upper bound of the range
  ///
  /// * Geo filters:
  /// - isFurtherThanOrAt which is the inclusive lower bound of the range
  /// - isLessFarThan which is the exclusive upper bound of the range
  /// By specifying one of the two parameters above, you need to specify the center point
  /// from where the range will be applied (from parameter which is a [LatLong]).
  /// The distance unit can also be specified [GeoUnit]
  ///
  /// Filters created with this modifier will be handled as "all" filters, which means
  /// that all conditions must match.
  ///
  /// Note: Nested filters are not supported at the moment.
  ///
  /// See [https://www.elastic.co/guide/en/app-search/current/filters.html]
  ElasticQuery filter(
    String field, {
    Object? isEqualTo,
    List<Object?>? whereIn,
    Object? isGreaterThanOrEqualTo,
    Object? isLessThan,
    double? isFurtherThanOrAt,
    double? isLessFarThan,
    LatLong? from,
    GeoUnit? unit,
  }) =>
      _filter(
        field,
        isEqualTo: isEqualTo,
        whereIn: whereIn,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        isLessThan: isLessThan,
        isFurtherThanOrAt: isFurtherThanOrAt,
        isLessFarThan: isLessFarThan,
        from: from,
        unit: unit,
        type: _ElasticFilterType.all,
      );

  /// Creates and returns a new [ElasticQuery] with additional [ElasticSearchFilter],
  /// an object to filter documents that contain a specific field value.
  /// Available on text, number, and date fields.
  ///
  /// Elastic filters can be of three types:
  /// * Value filters:
  /// - isEqualTo which will make a filter based on a value
  /// - whereIn which will make a filter based on an array of values
  ///
  /// * Range filters (works with `DateTime` and `double` types):
  /// - isGreaterThanOrEqualTo which is the inclusive lower bound of the range
  /// - isLessThan which is the exclusive upper bound of the range
  ///
  /// * Geo filters:
  /// - isFurtherThanOrAt which is the inclusive lower bound of the range
  /// - isLessFarThan which is the exclusive upper bound of the range
  /// By specifying one of the two parameters above, you need to specify the center point
  /// from where the range will be applied (from parameter which is a [LatLong]).
  /// The distance unit can also be specified [GeoUnit]
  ///
  /// Filters created with this modifier will be handled as "any" filters, which means
  /// that only one condition must match.
  ///
  /// Note: Nested filters are not supported at the moment.
  ///
  /// See [https://www.elastic.co/guide/en/app-search/current/filters.html]
  ElasticQuery filterAny(
    String field, {
    Object? isEqualTo,
    List<Object?>? whereIn,
    Object? isGreaterThanOrEqualTo,
    Object? isLessThan,
    double? isFurtherThanOrAt,
    double? isLessFarThan,
    LatLong? from,
    GeoUnit? unit,
  }) =>
      _filter(
        field,
        isEqualTo: isEqualTo,
        whereIn: whereIn,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        isLessThan: isLessThan,
        isFurtherThanOrAt: isFurtherThanOrAt,
        isLessFarThan: isLessFarThan,
        from: from,
        unit: unit,
        type: _ElasticFilterType.any,
      );

  /// Creates and returns a new [ElasticQuery] with additional [ElasticSearchFilter],
  /// an object to filter documents that contain a specific field value.
  /// Available on text, number, and date fields.
  ///
  /// Elastic filters can be of three types:
  /// * Value filters:
  /// - isEqualTo which will make a filter based on a value
  /// - whereIn which will make a filter based on an array of values
  ///
  /// * Range filters (works with `DateTime` and `double` types):
  /// - isGreaterThanOrEqualTo which is the inclusive lower bound of the range
  /// - isLessThan which is the exclusive upper bound of the range
  ///
  /// * Geo filters:
  /// - isFurtherThanOrAt which is the inclusive lower bound of the range
  /// - isLessFarThan which is the exclusive upper bound of the range
  /// By specifying one of the two parameters above, you need to specify the center point
  /// from where the range will be applied (from parameter which is a [LatLong]).
  /// The distance unit can also be specified [GeoUnit]
  ///
  /// Filters created with this modifier will be handled as "none" filters, which means
  /// that documents matching these filters will be excluded from results.
  ///
  /// Note: Nested filters are not supported at the moment.
  ///
  /// See [https://www.elastic.co/guide/en/app-search/current/filters.html]
  ElasticQuery filterNone(
    String field, {
    Object? isEqualTo,
    List<Object?>? whereIn,
    Object? isGreaterThanOrEqualTo,
    Object? isLessThan,
    double? isFurtherThanOrAt,
    double? isLessFarThan,
    LatLong? from,
    GeoUnit? unit,
  }) =>
      _filter(
        field,
        isEqualTo: isEqualTo,
        whereIn: whereIn,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        isLessThan: isLessThan,
        isFurtherThanOrAt: isFurtherThanOrAt,
        isLessFarThan: isLessFarThan,
        from: from,
        unit: unit,
        type: _ElasticFilterType.none,
      );

  /// Private method which handles filters.
  @Assert(
      'isEqualTo != null || whereIn != null || isGreaterThanOrEqualTo != null || isLessThan != null || isFurtherThanOrAt != null || isLessFarThan != null',
      'You must provide at least one condition (isEqualTo, whereIn, isGreaterThanOrEqualTo, isLessThan, isFurtherThanOrAt, isLessFarThan)')
  @Assert(
      '(isEqualTo != null && whereIn == null) || (isEqualTo == null && whereIn != null) || (isEqualTo == null && whereIn == null)',
      'You cannot use isEqualTo and whereIn at the same time.')
  @Assert(
      '(isEqualTo != null && isGreaterThanOrEqualTo == null && isLessThan == null) || (isEqualTo == null && (isGreaterThanOrEqualTo != null || isLessThan != null)) || (isEqualTo == null && isGreaterThanOrEqualTo == null && isLessThan == null)',
      'You cannot use isEqualTo and isGreaterThanOrEqualTo/isLessThan at the same time.')
  @Assert(
      '(isEqualTo != null && isFurtherThanOrAt == null && isLessFarThan == null) || (isEqualTo == null && (isFurtherThanOrAt != null || isLessFarThan != null)) || (isEqualTo == null && isFurtherThanOrAt == null && isLessFarThan == null)',
      'You cannot use isEqualTo and isFurtherThanOrAt/isLessFarThan at the same time.')
  @Assert(
      '((isFurtherThanOrAt != null || isLessFarThan != null) && isGreaterThanOrEqualTo == null && isLessThan == null) || ((isGreaterThanOrEqualTo != null || isLessThan != null) && isFurtherThanOrAt == null && isLessFarThan == null) || (isGreaterThanOrEqualTo == null && isLessThan == null && isFurtherThanOrAt == null && isLessFarThan == null)',
      'You cannot use isFurtherThanOrAt/isLessFarThan and isGreaterThanOrEqualTo/isLessThan at the same time.')
  @Assert(
      '((isFurtherThanOrAt != null || isLessFarThan != null) && from == null) || (isFurtherThanOrAt == null && isLessFarThan == null && from == null)',
      'You must provide from (which is the center point of your query) when using isFurtherThanOrAt/isLessFarThan.')
  ElasticQuery _filter(
    String field, {
    Object? isEqualTo,
    List<Object?>? whereIn,
    Object? isGreaterThanOrEqualTo,
    Object? isLessThan,
    double? isFurtherThanOrAt,
    double? isLessFarThan,
    LatLong? from,
    @Default(GeoUnit.meters) GeoUnit? unit,
    required _ElasticFilterType type,
  }) {
    dynamic value;

    if (whereIn != null) {
      value = whereIn;
    } else if (isEqualTo != null) {
      value = isEqualTo.toString();
    } else if (from != null) {
      value = _ElasticGeoFilter(
        center: from,
        unit: unit!,
        from: isFurtherThanOrAt,
        to: isLessFarThan,
      );
    } else if (isGreaterThanOrEqualTo != null || isLessThan != null) {
      if (isGreaterThanOrEqualTo is DateTime || isLessThan is DateTime) {
        value = _ElasticDateRangeFilter(
          from: (isGreaterThanOrEqualTo as DateTime?)?.toUTCString(),
          to: (isLessThan as DateTime?)?.toUTCString(),
        );
      } else if (isGreaterThanOrEqualTo is double ||
          isLessThan is double ||
          isGreaterThanOrEqualTo is int ||
          isLessThan is int) {
        value = _ElasticNumberRangeFilter(
          from: (isGreaterThanOrEqualTo as num?)?.toDouble(),
          to: (isLessThan as num?)?.toDouble(),
        );
      }
    }

    final List<_ElasticSearchFilter> newFilters = [
      ...?filters,
      _ElasticSearchFilter(
        type: type,
        name: field,
        value: value,
      ),
    ];

    // TO DO
    // Once all filters have been set, we must now check them
    // to ensure the query is valid.

    return copyWith(
      filters: newFilters,
    );
  }

  /// Takes a precision [int], creates and returns a new [ElasticQuery]
  /// See [https://www.elastic.co/guide/en/app-search/current/search-api-precision.html]
  //
  /// The value of the precision parameter must be an integer between 1 and 11, inclusive.
  /// The range of values represents a sliding scale that manages the inherent tradeoff between precision and recall.
  /// Lower values favor recall, while higher values favor precision.
  ElasticQuery precision(int value) => copyWith(precisionTuning: value);

  /// Takes a field with an optionnal `weight`, creates and returns a new [ElasticQuery]
  ///
  /// It will restrict a query to search only specific fields.
  ///
  /// Weight is given between 10 (most relevant) to 1 (least relevant).
  ///
  /// Restricting fields will result in faster queries, especially for schemas with many text fields
  /// Only available within text fields.
  ///
  /// See [https://www.elastic.co/guide/en/app-search/current/search-fields-weights.html]
  @Assert('weight != null && (weight < 1 || weight > 10)',
      'The value of the weight parameter must be an integer between 1 and 10.')
  ElasticQuery searchField(
    String field, {
    int? weight,
  }) {
    return copyWith(
      searchFields: [
        ...?searchFields,
        _ElasticSearchField(
          name: field,
          weight: weight,
        ),
      ],
    );
  }

  /// Creates and returns a new [ElasticQuery] with additional [ElasticResultField], an object
  /// which defines the fields which appear in search results and how their values are rendered.
  ///
  /// Raw: An exact representation of the value within a field.
  /// Snippet: A snippet is a representation of the value within a field, where query matches are returned
  /// in a specific field and other parts are splitted, in order to user [RichText] to display
  /// the results and highlight the query matches.
  /// The example of the package presents a use case of this feature.
  ///
  /// See [https://www.elastic.co/guide/en/app-search/current/result-fields-highlights.html]
  @Assert('rawSize == null || (rawSize != null && rawSize >= 20)',
      'Raw size must be at least 20.')
  @Assert('snippetSize == null || (snippetSize != null && snippetSize >= 20)',
      'Raw size must be at least 20.')
  ElasticQuery resultField(
    String field, {
    int? rawSize,
    int? snippetSize,
    bool fallback = true,
  }) {
    return copyWith(
      resultFields: [
        ...?resultFields,
        _ElasticResultField(
          name: field,
          rawSize: rawSize,
          snippetSize: snippetSize,
          fallback: fallback,
        ),
      ],
    );
  }

  /// Creates and returns a new [ElasticQuery] with additional [ElasticFacet], an object
  /// which rovides the counts of each value for a field, or counts of documents within the provided ranges
  /// if `isMoreThanOrEqualTo` or `isLessThan` is provided.
  ///
  /// See [https://www.elastic.co/guide/en/app-search/current/facets.html]
  @Assert(
      'isGreaterThanOrEqualTo == null || (isGreaterThanOrEqualTo != null && (isGreaterThanOrEqualTo is double || isGreaterThanOrEqualTo is DateTime))',
      '`isMoreThanOrEqualTo` must be a double or a DateTime')
  @Assert(
      'isLessThan == null || (isLessThan != null && (isLessThan is double || isLessThan is DateTime))',
      '`isLessThan` must be a double or a DateTime')
  @Assert(
      '(isEqualTo != null && isFurtherThanOrAt == null && isLessFarThan == null) || (isEqualTo == null && (isFurtherThanOrAt != null || isLessFarThan != null)) || (isEqualTo == null && isFurtherThanOrAt == null && isLessFarThan == null)',
      'You cannot use isEqualTo and isFurtherThanOrAt/isLessFarThan at the same time.')
  @Assert(
      '((isFurtherThanOrAt != null || isLessFarThan != null) && isGreaterThanOrEqualTo == null && isLessThan == null) || ((isGreaterThanOrEqualTo != null || isLessThan != null) && isFurtherThanOrAt == null && isLessFarThan == null) || (isGreaterThanOrEqualTo == null && isLessThan == null && isFurtherThanOrAt == null && isLessFarThan == null)',
      'You cannot use isFurtherThanOrAt/isLessFarThan and isGreaterThanOrEqualTo/isLessThan at the same time.')
  @Assert(
      '((isFurtherThanOrAt != null || isLessFarThan != null) && from == null) || (isFurtherThanOrAt == null && isLessFarThan == null && from == null)',
      'You must provide from (which is the center point of your query) when using isFurtherThanOrAt/isLessFarThan.')
  ElasticQuery facet(
    String field, {
    String? name,
    Object? isGreaterThanOrEqualTo,
    Object? isLessThan,
    Object? isFurtherThanOrAt,
    Object? isLessFarThan,
    LatLong? from,
    @Default(GeoUnit.meters) GeoUnit? unit,
    int? size,
    //List<ElasticRange>? ranges,
  }) {
    Map<String, _ElasticQueryFacet> _facets =
        facets != null ? {...facets!} : {};
    _ElasticQueryFacet facet;

    /*if (ranges != null) {
      facet = _ElasticQueryFacet(
        type: "range",
        ranges: ranges
            .map(
              (range) => _ElasticRangeFacet(
                name: range.name,
                from: range.from is DateTime
                    ? (range.from as DateTime).toUTCString()
                    : range.from?.toString(),
                to: range.to is DateTime
                    ? (range.to as DateTime).toUTCString()
                    : range.to?.toString(),
              ),
            )
            .toList(),
        center: center,
        unit: unit,
      );
    }*/
    if (from != null) {
      final newRange = _ElasticRangeFacet(
        name: name,
        from: isFurtherThanOrAt?.toString(),
        to: isLessFarThan?.toString(),
      );
      facet = _ElasticQueryFacet(
        type: "range",
        ranges: [
          ...?facets?[field]?.ranges,
          newRange,
        ],
        center: from,
        unit: unit,
      );
    } else if (isGreaterThanOrEqualTo != null || isLessThan != null) {
      final newRange = _ElasticRangeFacet(
        name: name,
        from: isGreaterThanOrEqualTo is DateTime
            ? isGreaterThanOrEqualTo.toUTCString()
            : isGreaterThanOrEqualTo?.toString(),
        to: isLessThan is DateTime
            ? isLessThan.toUTCString()
            : isLessThan?.toString(),
      );
      facet = _ElasticQueryFacet(
        type: "range",
        ranges: [
          ...?facets?[field]?.ranges,
          newRange,
        ],
      );
    } else {
      facet = _ElasticQueryFacet(
        type: "value",
        size: size,
      );
    }

    _facets[field] = facet;
    return copyWith(facets: _facets);
  }

  /// Creates and returns a new [ElasticQuery] with additional disjunctive facet.
  ///
  /// Disjunctive facets are useful when you have many filters in your form, and especially
  /// when you filter your query with a value that corresponds to a facet: if a disjunctive facet is set,
  /// it will return all the available facets as if that filter was not applied.
  @Assert('facets[field] != null',
      'No facet currently exists for this field. Please create your facet before call `disjunctiveFacet`.')
  ElasticQuery disjunctiveFacet(String field) {
    return copyWith(
      disjunctiveFacets: [
        ...?disjunctiveFacets,
        field,
      ],
    );
  }

  /// Creates and returns a new [ElasticQuery] with additional analytics tag.
  ///
  /// See [https://www.elastic.co/guide/en/app-search/current/tags.html]
  @Assert('tag.length > 64', 'A tag is limited to 64 characters.')
  ElasticQuery tag(String tag) {
    return copyWith(
      analytics: _ElasticAnalytics(
        tags: [
          ...?analytics?.tags,
          tag,
        ],
      ),
    );
  }

  /// Takes a field with an optionnal `size`, creates and returns a new [ElasticQuery]
  /// which will return grouped results based on shared fields.
  ///
  /// See [https://www.elastic.co/guide/en/app-search/current/grouping.html]
  @Assert('field != null', 'Field name to group results on must not be null')
  @Assert('size == null || (size != null && size >= 1 && size <= 10',
      'size must be between 1 and 10')
  ElasticQuery group(
    String field, {
    int? size,
  }) {
    return copyWith(
      groupBy: _ElasticGroup(
        field: field,
        size: size,
      ),
    );
  }

  /// Takes a field with an optionnal `descending`, creates and returns a new [ElasticQuery]
  /// which will sort your results in an order other than document score.
  ///
  /// See [https://www.elastic.co/guide/en/app-search/current/sort.html]
  @Assert('field != null', 'Field name to sort results must not be null')
  ElasticQuery sort(
    String field, {
    bool descending = false,
  }) {
    final newSortBy = _ElasticSort(
      field: field,
      descending: descending,
    );
    return copyWith(sortBy: sortBy ?? <_ElasticSort>[] + [newSortBy]);
  }

  /// Creates and returns a new [ElasticQuery] with new pagination parameters.
  ///
  /// See [https://www.elastic.co/guide/en/app-search/current/search-guide.html#search-guide-paginate]
  ElasticQuery page(
    int current, {
    int size = 10,
  }) {
    return copyWith(
      searchPage: _ElasticSearchPage(
        current: current,
        size: size,
      ),
    );
  }

  /// Fetch the documents for this query.
  Future<ElasticResponse> get([CancelToken? cancelToken]) {
    return engine!.get(this, cancelToken);
  }

  /// Private method - not intended to be used
  /// Builds the list of the disjunctive queries that will be passed
  /// at the same time of the main query, when disjunctive facets are set.
  List<ElasticQuery>? get _disjunctives {
    if (disjunctiveFacets == null || disjunctiveFacets!.isEmpty) return null;
    List<ElasticQuery> _disjunctives = [];

    for (String field in disjunctiveFacets ?? []) {
      final _disjunctiveQuery = _disjunctive(field);
      if (_disjunctiveQuery != null) {
        _disjunctives.add(_disjunctiveQuery);
      }
    }
    return _disjunctives;
  }

  /// Private method - not intended to be used
  /// Build a disjunctive query when disjunctive facets are set.
  ElasticQuery? _disjunctive(String field) {
    final disjunctiveFilters =
        filters?.where((filter) => filter.name != field).toList();
    final disjunctiveFacets = facets?[field];

    if (filters?.length == disjunctiveFilters?.length) return null;

    return copyWith(
      filters: disjunctiveFilters,
      facets: disjunctiveFacets != null ? {field: disjunctiveFacets} : null,
    ).page(1, size: 0).resultField(field).tag("Facet-Only");
  }
}

/// Object to delimit the pagination parameters.
///
/// See [https://www.elastic.co/guide/en/app-search/current/search-guide.html#search-guide-paginate]
@freezed
class _ElasticSearchPage with _$ElasticSearchPage {
  @JsonSerializable(explicitToJson: true, includeIfNull: false)
  @Assert('size == null || (size != null && size >= 0 && size <= 1000)',
      'The number of results per page must be greater than or equal to 1 and less than or equal to 1000.')
  @Assert(
      'current == null || (current != null && current >= 1 && current <= 100)',
      'The current must be greater than or equal to 1 and less than or equal to 100.')
  const factory _ElasticSearchPage({
    /// Number of results per page.
    /// Must be greater than or equal to 1 and less than or equal to 1000.
    /// Defaults to 10.
    @Default(10) int? size,

    /// Page number of results to return.
    /// Must be greater than or equal to 1 and less than or equal to 100.
    /// Defaults to 1.
    @Default(1) int? current,
  }) = __ElasticSearchPage;

  factory _ElasticSearchPage.fromJson(Map<String, dynamic> json) =>
      _$ElasticSearchPageFromJson(json);
}

/// Object to filter documents that contain a specific field value.
/// Available on text, number, and date fields.
///
/// Note: As for now, this object only handles "all" filters, which means that all
/// the filters added to the query will be handled as a "AND" query.
/// The other filters available, "or" and "not", will be added in a future release
/// of the package.
///
/// See [https://www.elastic.co/guide/en/app-search/current/filters.html]
@freezed
class _ElasticSearchFilter with _$ElasticSearchFilter {
  @JsonSerializable(explicitToJson: true, includeIfNull: false)
  const factory _ElasticSearchFilter({
    /// The type of the filter, which will determine if it's an 'OR', 'AND' or 'NOT' condition.
    @Default(_ElasticFilterType.all) _ElasticFilterType type,

    /// The field from your schema upon which to apply your filter.
    required String name,

    /// The value upon which to filter. The value must be an exact match,
    /// and can be a String, a boolean, a number, or an array of these types.
    required dynamic value,
  }) = __ElasticSearchFilter;

  factory _ElasticSearchFilter.fromJson(Map<String, dynamic> json) =>
      _$ElasticSearchFilterFromJson(json);
}

class _ElasticSearchFiltersConverter
    implements JsonConverter<List<_ElasticSearchFilter>?, Map?> {
  const _ElasticSearchFiltersConverter();

  @override
  List<_ElasticSearchFilter>? fromJson(Map? value) => null;

  @override
  Map? toJson(List<_ElasticSearchFilter>? searchFilters) {
    if (searchFilters == null) return null;
    Map<String, dynamic> filters = {};

    for (final type in _ElasticFilterType.values) {
      var values = [];
      for (final searchFilter
          in searchFilters.where((filter) => filter.type == type)) {
        if (searchFilter.value is _ElasticDateRangeFilter) {
          final encodedValue =
              (searchFilter.value as _ElasticDateRangeFilter).toJson();
          values.add({searchFilter.name: encodedValue});
        } else if (searchFilter.value is _ElasticNumberRangeFilter) {
          final encodedValue =
              (searchFilter.value as _ElasticNumberRangeFilter).toJson();
          values.add({searchFilter.name: encodedValue});
        } else if (searchFilter.value is _ElasticGeoFilter) {
          final encodedValue =
              (searchFilter.value as _ElasticGeoFilter).toJson();
          values.add({searchFilter.name: encodedValue});
        } else {
          values.add({searchFilter.name: searchFilter.value});
        }
      }

      filters[type.name] = values.length == 1 ? values.first : values;
    }
    return filters;
  }
}

@freezed
class _ElasticDateRangeFilter with _$ElasticDateRangeFilter {
  @JsonSerializable(explicitToJson: true, includeIfNull: false)
  const factory _ElasticDateRangeFilter({
    String? from,
    String? to,
  }) = __ElasticDateRangeFilter;

  factory _ElasticDateRangeFilter.fromJson(Map<String, dynamic> json) =>
      _$ElasticDateRangeFilterFromJson(json);
}

@freezed
class _ElasticNumberRangeFilter with _$ElasticNumberRangeFilter {
  @JsonSerializable(explicitToJson: true, includeIfNull: false)
  const factory _ElasticNumberRangeFilter({
    double? from,
    double? to,
  }) = __ElasticNumberRangeFilter;

  factory _ElasticNumberRangeFilter.fromJson(Map<String, dynamic> json) =>
      _$ElasticNumberRangeFilterFromJson(json);
}

@freezed
class _ElasticGeoFilter with _$ElasticGeoFilter {
  @JsonSerializable(explicitToJson: true, includeIfNull: false)
  @Assert('center != null', 'center is required.')
  const factory _ElasticGeoFilter({
    @_LatLongConverter() LatLong? center,
    double? distance,
    required GeoUnit unit,
    double? from,
    double? to,
  }) = __ElasticGeoFilter;

  factory _ElasticGeoFilter.fromJson(Map<String, dynamic> json) =>
      _$ElasticGeoFilterFromJson(json);
}

/// Object which restricts a query to search only specific fields.
///
/// Restricting fields will result in faster queries, especially for schemas with many text fields
/// Only available within text fields.
///
/// See [https://www.elastic.co/guide/en/app-search/current/search-fields-weights.html]
@freezed
class _ElasticSearchField with _$ElasticSearchField {
  @JsonSerializable(explicitToJson: true, includeIfNull: false)
  const factory _ElasticSearchField({
    /// The name of the field. It must exist within your Engine schema and be of type text.
    required String name,

    /// Optionnal. Apply Weights to each search field.
    /// Engine level Weight settings will be applied is none are provided.
    int? weight,
  }) = __ElasticSearchField;

  factory _ElasticSearchField.fromJson(Map<String, dynamic> json) =>
      _$ElasticSearchFieldFromJson(json);
}

class _ElasticSearchFieldsConverter
    implements JsonConverter<List<_ElasticSearchField>?, Map?> {
  const _ElasticSearchFieldsConverter();

  @override
  List<_ElasticSearchField>? fromJson(Map? value) => null;

  @override
  Map? toJson(List<_ElasticSearchField>? searchFields) {
    if (searchFields == null) return null;

    var value = {};
    for (final searchField in searchFields) {
      if (searchField.weight != null) {
        value[searchField.name] = {
          "weight": searchField.weight,
        };
      } else {
        value[searchField.name] = {};
      }
    }
    return value;
  }
}

/// Object to define the fields which appear in search results and how their values are rendered.
///
/// Raw: An exact representation of the value within a field.
/// Snippet: A snippet is a representation of the value within a field, where query matches are returned
/// in a specific field and other parts are splitted, in order to user [RichText] to display
/// the results and highlight the query matches.
/// The example of the package presents a use case of this feature.
///
/// More information on [https://www.elastic.co/guide/en/app-search/current/result-fields-highlights.html]
@freezed
class _ElasticResultField with _$ElasticResultField {
  @JsonSerializable(explicitToJson: true, includeIfNull: false)
  const factory _ElasticResultField({
    /// The name of the field. It must exist within your Engine schema and be of type text.
    required String name,

    /// Length of the return value.
    /// Must be at least 20; defaults to the entire text field.
    /// If given for a different field type other than text, it will be silently ignored.
    int? rawSize,

    /// Length of the snippet returned.
    /// Must be at least 20; defaults to 100.
    int? snippetSize,

    /// If true, return the raw text field if no snippet is found. If false, only use snippets.
    @Default(true) bool fallback,
  }) = __ElasticResultField;

  factory _ElasticResultField.fromJson(Map<String, dynamic> json) =>
      _$ElasticResultFieldFromJson(json);
}

class _ElasticResultFieldsConverter
    implements JsonConverter<List<_ElasticResultField>?, Map?> {
  const _ElasticResultFieldsConverter();

  @override
  List<_ElasticResultField>? fromJson(Map? value) => null;

  @override
  Map? toJson(List<_ElasticResultField>? resultFields) {
    if (resultFields == null || resultFields.isEmpty) return null;

    var value = <String, Map?>{};
    for (final resultField in resultFields) {
      value[resultField.name] = {
        "raw": resultField.rawSize != null ? {"size": resultField.rawSize} : {}
      };
      if (resultField.snippetSize != null) {
        value[resultField.name]!["snippet"] = {
          "size": resultField.snippetSize,
          "fallback": resultField.fallback,
        };
      }
    }
    return value;
  }
}

/// Object which generate grouped results based on shared fields.
///
/// The most relevant document will have a _group key.
/// The key includes all other documents that share an identical value within the grouped field.
/// Documents in the _group key will not appear anywhere else in the search response.
///
/// See [https://www.elastic.co/guide/en/app-search/current/grouping.html]
@freezed
class _ElasticGroup with _$ElasticGroup {
  @JsonSerializable(explicitToJson: true, includeIfNull: false)
  const factory _ElasticGroup({
    /// Field name to group results on.
    required String field,

    /// Number of results to be included in the _group key of the returned document.
    /// Can be between 1 and 10. Defaults to 10.
    int? size,
  }) = __ElasticGroup;

  factory _ElasticGroup.fromJson(Map<String, dynamic> json) =>
      _$ElasticGroupFromJson(json);
}

/// Object which sorts results based on shared fields.
///
/// Sort your results in an order other than document score.
/// Using sort will override the default relevance scoring method.
///
/// See [https://www.elastic.co/guide/en/app-search/current/sort.html]
@freezed
class _ElasticSort with _$ElasticSort {
  @JsonSerializable(explicitToJson: true, includeIfNull: false)
  const factory _ElasticSort({
    /// Field name to sort results
    required String field,
    @Default(false) bool descending,
  }) = __ElasticSort;

  factory _ElasticSort.fromJson(Map<String, dynamic> json) =>
      _$ElasticSortFromJson(json);
}

class _ElasticSortConverter
    implements JsonConverter<List<_ElasticSort>?, List<Map>?> {
  const _ElasticSortConverter();

  @override
  List<_ElasticSort>? fromJson(List<Map>? value) => null;

  @override
  List<Map>? toJson(List<_ElasticSort>? sortBys) {
    if (sortBys == null || sortBys.isEmpty) return null;
    var value = <Map<String, String>>[];
    for (final sortBy in sortBys) {
      value.add({sortBy.field: sortBy.descending ? "desc" : "asc"});
    }
    return value;
  }
}

@freezed
class ElasticSuggestionsQuery with _$ElasticSuggestionsQuery {
  const ElasticSuggestionsQuery._();

  @JsonSerializable(
    explicitToJson: true,
    includeIfNull: false,
  )
  @Assert('engine != null', 'An engine is required to build a query.')
  const factory ElasticSuggestionsQuery({
    /// An object representing an Elastic engine
    @JsonKey(includeToJson: false, includeFromJson: false)
    ElasticEngine? engine,

    /// String or number to match.
    required String query,

    /// Number of query suggestions.
    /// Must be greater than or equal to 1 and less than or equal to 1000.
    /// Defaults to 10.
    @JsonKey(name: "size") @Default(10) int? sizeField,

    /// Object which restricts a query to search only specific fields.
    @_ElasticSearchFieldsConverter()
    @JsonKey(name: "search_fields")
    List<_ElasticSearchField>? searchFields,

    /// Object to sort your results in an order other than document score.
    @_ElasticSortConverter() @JsonKey(name: "sort") List<_ElasticSort>? sortBy,
  }) = _ElasticSuggestionsQuery;

  factory ElasticSuggestionsQuery.fromJson(Map<String, dynamic> json) =>
      _$ElasticSuggestionsQueryFromJson(json);

  /// Takes a field with an optional `weight`, creates and returns a new [ElasticSuggestionsQuery]
  ///
  /// It will restrict a query to search only specific fields.
  ///
  /// Weight is given between 10 (most relevant) to 1 (least relevant).
  ///
  /// Restricting fields will result in faster queries, especially for schemas with many text fields
  /// Only available within text fields.
  ///
  /// See [https://www.elastic.co/guide/en/app-search/current/search-fields-weights.html]
  @Assert('weight != null && (weight < 1 || weight > 10)',
      'The value of the weight parameter must be an integer between 1 and 10.')
  ElasticSuggestionsQuery searchField(
    String field, {
    int? weight,
  }) {
    return copyWith(
      searchFields: [
        ...?searchFields,
        _ElasticSearchField(
          name: field,
          weight: weight,
        ),
      ],
    );
  }

  /// Takes a field with an optionnal `descending`, creates and returns a new [ElasticSuggestionsQuery]
  /// which will sort your results in an order other than document score.
  ///
  /// See [https://www.elastic.co/guide/en/app-search/current/sort.html]
  @Assert('field != null', 'Field name to sort results must not be null')
  ElasticSuggestionsQuery sort(
    String field, {
    bool descending = false,
  }) {
    final newSortBy = _ElasticSort(
      field: field,
      descending: descending,
    );
    return copyWith(sortBy: sortBy ?? <_ElasticSort>[] + [newSortBy]);
  }

  /// Creates and returns a new [ElasticSuggestionsQuery] with new size parameters.
  ElasticSuggestionsQuery size(
    int size,
  ) {
    return copyWith(
      sizeField: size,
    );
  }

  /// Fetch the documents for this query.
  Future<ElasticQuerySuggestionResponse> get([CancelToken? cancelToken]) {
    return engine!.getQuerySuggestion(this, cancelToken);
  }
}
