import { apiRequest } from "@/api/client";

export function fetchAppointments(token, { pageNum = 1, pageSize = 10 } = {}) {
  return apiRequest(`/appointments?pageNum=${pageNum}&pageSize=${pageSize}`, { token });
}

export function cancelAppointment(token, id) {
  return apiRequest(`/appointments/${id}/cancel`, {
    method: "PUT",
    token
  });
}

export function createAppointment(token, body) {
  return apiRequest("/appointments", {
    method: "POST",
    token,
    body
  });
}
