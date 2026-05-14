const API_PREFIX = "/api";
const TOKEN_PREFIX = "Bearer ";

function buildHeaders(token, hasBody) {
  const headers = {
    Accept: "application/json"
  };

  if (hasBody) {
    headers["Content-Type"] = "application/json";
  }

  if (token) {
    headers.Authorization = token.startsWith(TOKEN_PREFIX) ? token : `${TOKEN_PREFIX}${token}`;
  }

  return headers;
}

function parseFieldErrors(data) {
  const errors = data?.errors;
  if (!Array.isArray(errors)) {
    return "";
  }
  return errors.map((item) => `${item.field}: ${item.message}`).join("；");
}

export async function apiRequest(path, options = {}) {
  const { body, token, ...restOptions } = options;
  const response = await fetch(`${API_PREFIX}${path}`, {
    ...restOptions,
    headers: buildHeaders(token, body !== undefined),
    body: body === undefined ? undefined : JSON.stringify(body)
  });

  const payload = await response.json().catch(() => null);
  const fieldErrorMessage = parseFieldErrors(payload?.data);
  const message =
    fieldErrorMessage ||
    payload?.message ||
    `请求失败（HTTP ${response.status || "unknown"}）`;

  if (!response.ok || payload?.code !== 200) {
    const error = new Error(message);
    error.status = response.status;
    error.payload = payload;
    throw error;
  }

  return payload.data;
}
