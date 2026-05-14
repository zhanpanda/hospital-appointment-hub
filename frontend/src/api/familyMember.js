import { apiRequest } from "@/api/client";

export function fetchFamilyMembers(token) {
  return apiRequest("/family-member", { token });
}

export function fetchFamilyMemberDetail(token, id) {
  return apiRequest(`/family-member/${id}`, { token });
}

export function createFamilyMember(token, body) {
  return apiRequest("/family-member", {
    method: "POST",
    token,
    body
  });
}

export function updateFamilyMember(token, id, body) {
  return apiRequest(`/family-member/${id}`, {
    method: "PUT",
    token,
    body
  });
}

export function deleteFamilyMemberById(token, id) {
  return apiRequest(`/family-member/${id}`, {
    method: "DELETE",
    token
  });
}

export function setDefaultFamilyMember(token, id) {
  return apiRequest(`/family-member/${id}/default`, {
    method: "PUT",
    token
  });
}
