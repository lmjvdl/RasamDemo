"use client";

import ModalForm from "@/components/AdminPanelComponent/AddingProcess/ModalForm";
import MainCard from "@/components/CustomContiner/MainCard";
import UserView from "./UserViewTable";

export default function UserPage() {
  return (
    <MainCard>
      <ModalForm
        buttonText="افزودن کاربر جدید"
        formFields={[
          { name: "username", label: "نام کاربری", type: "text" },
          { name: "password", label: "رمز عبور", type: "password" },
          { name: "firstName", label: "نام", type: "text" },
          { name: "lastName", label: "نام خانوادگی", type: "text" },
          { name: "phoneNumber", label: "شماره تلفن", type: "tel" },
          { name: "email", label: "ایمیل", type: "email" },
          {
            name: "permission",
            label: "سطح دسترسی",
            type: "multiselect",
            options: [
              { label: "مدیر", value: "admin" },
              { label: "کاربر", value: "user" },
              { label: "ویراستار", value: "editor" },
              { label: "مهمان", value: "guest" },
            ],
          },
        ]}
        onSubmit={async (data) => {
          try {
            console.log("📝 اطلاعات ارسال شده:", data);
            return { success: true };
          } catch (error) {
            return { success: false, error: "مشکلی پیش آمد" };
          }
        }}
      />
      <UserView />
    </MainCard>
  );
}