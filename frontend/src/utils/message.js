import { ElMessage } from "element-plus";
import { getErrorMessage } from "@/utils/error";

export function showSuccessMessage(message) {
  ElMessage({
    message,
    type: "success",
    grouping: true,
    offset: 88
  });
}

export function showErrorMessage(error) {
  ElMessage({
    message: getErrorMessage(error),
    type: "error",
    grouping: true,
    offset: 88
  });
}
