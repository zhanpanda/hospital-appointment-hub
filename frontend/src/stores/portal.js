import { computed, reactive } from "vue";
import { fetchDepartments } from "@/api/department";
import { fetchDoctorDetail, fetchDoctors } from "@/api/doctor";
import { fetchFamilyMembers } from "@/api/familyMember";

function createDoctorPage() {
  return {
    records: [],
    current: 1,
    size: 6,
    total: 0,
    pages: 0
  };
}

const state = reactive({
  dashboardLoading: false,
  doctorsLoading: false,
  doctorDetailLoading: false,
  familyLoading: false,
  selectedDepartmentId: null,
  departments: [],
  doctorPage: createDoctorPage(),
  doctorDetail: null,
  familyMembers: []
});

const selectedDepartmentName = computed(
  () => state.departments.find((item) => item.id === state.selectedDepartmentId)?.name || "未选择科室"
);

function clearState() {
  state.dashboardLoading = false;
  state.doctorsLoading = false;
  state.doctorDetailLoading = false;
  state.familyLoading = false;
  state.selectedDepartmentId = null;
  state.departments = [];
  state.doctorPage = createDoctorPage();
  state.doctorDetail = null;
  state.familyMembers = [];
}

async function loadDepartments(token) {
  const data = await fetchDepartments(token);
  state.departments = Array.isArray(data) ? data : [];

  if (!state.departments.length) {
    state.selectedDepartmentId = null;
    return;
  }

  const hasCurrentSelection = state.departments.some(
    (item) => item.id === state.selectedDepartmentId
  );
  state.selectedDepartmentId = hasCurrentSelection
    ? state.selectedDepartmentId
    : state.departments[0].id;
}

async function loadDoctorDetail(token, id) {
  if (!id) {
    state.doctorDetail = null;
    return;
  }

  state.doctorDetailLoading = true;
  try {
    state.doctorDetail = await fetchDoctorDetail(token, id);
  } finally {
    state.doctorDetailLoading = false;
  }
}

async function loadDoctors(token, pageNum = 1) {
  if (!state.selectedDepartmentId) {
    state.doctorPage = createDoctorPage();
    state.doctorDetail = null;
    return;
  }

  state.doctorsLoading = true;
  try {
    const data = await fetchDoctors(token, {
      departmentId: state.selectedDepartmentId,
      pageNum,
      pageSize: 6
    });

    state.doctorPage = {
      records: data?.records || [],
      current: data?.current || pageNum,
      size: data?.size || 6,
      total: data?.total || 0,
      pages: data?.pages || 0
    };
    state.doctorDetail = null;
  } finally {
    state.doctorsLoading = false;
  }
}

async function loadFamilyMemberList(token) {
  state.familyLoading = true;
  try {
    const data = await fetchFamilyMembers(token);
    state.familyMembers = Array.isArray(data) ? data : [];
  } finally {
    state.familyLoading = false;
  }
}

async function bootstrap(token) {
  if (!token) {
    return;
  }

  state.dashboardLoading = true;
  try {
    await loadDepartments(token);
    await Promise.all([loadDoctors(token, 1), loadFamilyMemberList(token)]);
  } finally {
    state.dashboardLoading = false;
  }
}

export function usePortalStore() {
  return {
    state,
    selectedDepartmentName,
    clearState,
    loadDepartments,
    loadDoctorDetail,
    loadDoctors,
    loadFamilyMembers: loadFamilyMemberList,
    bootstrap
  };
}
