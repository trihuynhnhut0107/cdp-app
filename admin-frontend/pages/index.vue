<template>
  <div class="min-h-screen bg-gray-50 py-8">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="mb-8">
        <div class="flex justify-between items-center">
          <div>
            <h1 class="text-3xl font-bold text-gray-900">Survey Management</h1>
            <p class="mt-2 text-gray-600">Manage and view all your surveys</p>
          </div>
          <NuxtLink
            to="/create-survey"
            class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition-colors duration-200 font-medium">
            Create Survey
          </NuxtLink>
        </div>
      </div>

      <!-- Loading State -->
      <div v-if="pending" class="flex justify-center items-center py-12">
        <div
          class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>

      <!-- Error State -->
      <div
        v-else-if="error"
        class="bg-red-50 border border-red-200 rounded-lg p-4">
        <div class="flex">
          <div class="flex-shrink-0">
            <svg
              class="h-5 w-5 text-red-400"
              viewBox="0 0 20 20"
              fill="currentColor">
              <path
                fill-rule="evenodd"
                d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"
                clip-rule="evenodd" />
            </svg>
          </div>
          <div class="ml-3">
            <h3 class="text-sm font-medium text-red-800">
              Error loading surveys
            </h3>
            <p class="mt-1 text-sm text-red-700">{{ error }}</p>
          </div>
        </div>
      </div>

      <!-- Surveys Grid -->
      <div
        v-else-if="surveys && surveys.length > 0"
        class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <div
          v-for="survey in surveys"
          :key="survey.id"
          :class="[
            'rounded-lg shadow-md hover:shadow-lg transition-shadow duration-200',
            survey.disabled ? 'bg-red-50 border border-red-200' : 'bg-white',
          ]">
          <div class="p-6">
            <div class="flex items-center justify-between mb-4">
              <h3
                :class="[
                  'text-lg font-semibold',
                  survey.disabled ? 'text-red-700' : 'text-gray-900',
                ]">
                {{ survey.survey_name }}
                <span
                  v-if="survey.disabled"
                  class="ml-2 text-xs px-2 py-1 bg-red-100 text-red-700 rounded-full">
                  DISABLED
                </span>
              </h3>
            </div>

            <div class="space-y-2 mb-4">
              <div
                :class="[
                  'flex items-center text-sm',
                  survey.disabled ? 'text-red-600' : 'text-gray-600',
                ]">
                <svg
                  class="w-4 h-4 mr-2"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24">
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                </svg>
                {{ survey.question_quantity }} questions
              </div>

              <div
                :class="[
                  'flex items-center text-sm',
                  survey.disabled ? 'text-red-600' : 'text-gray-600',
                ]">
                <svg
                  class="w-4 h-4 mr-2"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24">
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1"></path>
                </svg>
                {{ survey.point }} points
              </div>

              <div
                :class="[
                  'flex items-center text-sm',
                  survey.disabled ? 'text-red-600' : 'text-gray-600',
                ]">
                <svg
                  class="w-4 h-4 mr-2"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24">
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                </svg>
                {{ formatDate(survey.createdAt) }}
              </div>
            </div>

            <div class="flex space-x-3">
              <NuxtLink
                :to="`/survey/${survey.id}`"
                class="flex-1 bg-blue-600 text-white text-center py-2 px-4 rounded-md hover:bg-blue-700 transition-colors duration-200 text-sm font-medium">
                View Answers
              </NuxtLink>

              <button
                v-if="!survey.disabled"
                @click="disableSurvey(survey.id)"
                class="flex-1 bg-gray-100 text-gray-700 text-center py-2 px-4 rounded-md hover:bg-gray-200 transition-colors duration-200 text-sm font-medium">
                Disable Survey
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Empty State -->
      <div v-else class="text-center py-12">
        <svg
          class="mx-auto h-12 w-12 text-gray-400"
          fill="none"
          viewBox="0 0 24 24"
          stroke="currentColor">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M9 5H7a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"></path>
        </svg>
        <h3 class="mt-2 text-sm font-medium text-gray-900">No surveys found</h3>
        <p class="mt-1 text-sm text-gray-500">
          Get started by creating a new survey.
        </p>
        <div class="mt-6">
          <NuxtLink
            to="/create-survey"
            class="bg-blue-600 text-white px-6 py-3 rounded-md hover:bg-blue-700 transition-colors duration-200 font-medium">
            Create Your First Survey
          </NuxtLink>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
interface Survey {
  id: string;
  question_quantity: number;
  survey_name: string;
  point: number;
  createdAt: string;
  updatedAt: string;
  answered: boolean;
  disabled: boolean;
}

interface SurveyResponse {
  message: string;
  status: number;
  metadata: Survey[];
}

// Fetch surveys from API
const {
  data: response,
  pending,
  error,
  refresh,
} = await useFetch<SurveyResponse>("http://localhost:8000/survey");

// Extract surveys from response
const surveys = computed(() => response.value?.metadata || []);

// Disable survey function
const disableSurvey = async (surveyId: string) => {
  try {
    await $fetch(`http://localhost:8000/survey/${surveyId}/disable`, {
      method: "PATCH",
    });

    // Refetch all surveys after successful disable
    await refresh();
  } catch (error) {
    console.error("Error disabling survey:", error);
    // You might want to show a toast notification here
  }
};

// Format date helper
const formatDate = (dateString: string) => {
  return new Date(dateString).toLocaleDateString("en-US", {
    year: "numeric",
    month: "short",
    day: "numeric",
  });
};

// Set page title
useHead({
  title: "Surveys - Admin Dashboard",
});
</script>

<style scoped>
/* Additional custom styles if needed */
</style>
