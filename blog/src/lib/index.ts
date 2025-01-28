import { type ClassValue, clsx } from 'clsx';
import { twMerge } from 'tailwind-merge';

// Convert string to sentence case
export function routeToSentenceCase(str: string) {
	const route = str === '/' ? 'Home' : str.slice(1);
	return route.charAt(0).toUpperCase() + route.slice(1).toLowerCase();
}

// Combine classes conditionally
export function cn(...inputs: ClassValue[]) {
	return twMerge(clsx(inputs));
}
