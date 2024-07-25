part of elastic_app_search;

/// An object containing the response for a given query
///
/// See [https://www.elastic.co/guide/en/app-search/current/search.html]
@freezed
class ElasticResponse with _$ElasticResponse {
  ElasticResponse._();

  factory ElasticResponse({
    /// Object delimiting the results meta data.
    required ElasticResponseMeta meta,

    /// Array of results matching the search.
    required List<ElasticResult> results,

    /// Map of facets passed to the query
    @JsonKey(name: "facets") Map<String, List<ElasticFacet>>? rawFacets,
  }) = _ElasticResponse;

  factory ElasticResponse.fromJson(Map<String, dynamic> json) =>
      _$ElasticResponseFromJson(json);

  /// Easier way to retrieve a list of facets rather than use the raw map
  List<ElasticFacet>? facets(String field) => rawFacets?[field];

  /// Easier way to retrieve a single facet
  ElasticFacet? facet(String field) {
    final facets = rawFacets?[field];
    if (facets != null && facets.length == 1) return facets.first;
    return null;
  }
}

/// Object delimiting the results meta data.
///
/// See [https://www.elastic.co/guide/en/app-search/current/search.html#search-api-response-body]
@freezed
class ElasticResponseMeta with _$ElasticResponseMeta {
  factory ElasticResponseMeta({
    /// String ID representing the request. Guaranteed to be unique.
    @JsonKey(name: "request_id") required String requestId,

    /// Array of warnings for the query.
    ///
    /// Included with error responses and success responses, so inspect all responses for warnings.
    required List<dynamic> warnings,

    /// Array of alerts for your deployment.
    ///
    /// Included with error responses and success responses, so inspect all responses for alerts.
    required List<dynamic> alerts,

    /// Object delimiting the pagination meta data.
    required ElasticResponseMetaPage page,
  }) = _ElasticResponseMeta;

  factory ElasticResponseMeta.fromJson(Map<String, dynamic> json) =>
      _$ElasticResponseMetaFromJson(json);
}

/// Object delimiting the pagination meta data.
@freezed
class ElasticResponseMetaPage with _$ElasticResponseMetaPage {
  factory ElasticResponseMetaPage({
    /// Number representing the current page of results.
    required int current,

    /// Number representing the results per page.
    required int size,

    /// Number representing the total pages of results.
    /// Value is 0 when you paginate beyond 10,000 results.
    ///
    /// See [https://www.elastic.co/guide/en/app-search/current/search-guide.html#search-guide-paginate]
    @JsonKey(name: "total_pages") required int totalPages,

    /// Number representing the total results across all pages.
    ///
    /// The values 0 through 9999 are exact counts.
    ///
    /// The value 10000 is a pseudo keyword representing greater than or equal to 10,000 results.
    ///
    /// See [https://www.elastic.co/guide/en/app-search/current/search-guide.html#search-guide-display-total]
    /// and [https://www.elastic.co/guide/en/app-search/current/search-guide.html#search-guide-count-documents]
    @JsonKey(name: "total_results") required int totalResults,
  }) = _ElasticResponseMetaPage;

  factory ElasticResponseMetaPage.fromJson(Map<String, dynamic> json) =>
      _$ElasticResponseMetaPageFromJson(json);
}

@freezed
class ElasticQuerySuggestionResponse with _$ElasticQuerySuggestionResponse {
  ElasticQuerySuggestionResponse._();

  factory ElasticQuerySuggestionResponse({
    /// Documents containing the suggestions
    required ElasticSuggestionResult results,
  }) = _ElasticQuerySuggestionResponse;

  factory ElasticQuerySuggestionResponse.fromJson(Map<String, dynamic> json) =>
      _$ElasticQuerySuggestionResponseFromJson(json);
}