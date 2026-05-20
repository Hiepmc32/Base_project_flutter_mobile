/// Extra key for requests that should skip auth header attachment.
const String kSkipAuthHeader = 'skip_auth_header';

/// Extra key for requests that should skip waiting for refresh queue.
const String kSkipRefreshQueue = 'skip_refresh_queue';

/// Extra key for requests that should skip refresh-token handling.
const String kSkipTokenRefresh = 'skip_token_refresh';

/// Extra key marking a request already retried after token refresh.
const String kRetriedAfterRefresh = 'retried_after_refresh';

/// Extra key for requests that should bypass connectivity guard.
const String kSkipConnectivityGuard = 'skip_connectivity_guard';
