import { apiRequest } from "@/api/client";

export function loginByPhone(payload) {
  return apiRequest("/patient/login/phone", {
    method: "POST",
    body: payload
  });
}

export function loginByEmail(payload) {
  return apiRequest("/patient/login/email", {
    method: "POST",
    body: payload
  });
}

export function registerByPhone(payload) {
  return apiRequest("/patient/register/phone", {
    method: "POST",
    body: payload
  });
}

export function registerByEmail(payload) {
  return apiRequest("/patient/register/email", {
    method: "POST",
    body: payload
  });
}

export function logoutPatient(token) {
  return apiRequest("/patient/logout", {
    method: "POST",
    token
  });
}
