import { apiRequest } from "@/api/client";

export function fetchDoctors(token, { departmentId, pageNum = 1, pageSize = 6 }) {
  return apiRequest(
    `/doctors?departmentId=${departmentId}&pageNum=${pageNum}&pageSize=${pageSize}`,
    { token }
  );
}

export function fetchDoctorDetail(token, id) {
  return apiRequest(`/doctors/${id}`, { token });
}
