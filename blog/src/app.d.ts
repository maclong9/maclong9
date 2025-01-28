// See https://svelte.dev/docs/kit/types#app.d.ts
// for information about these interfaces
declare global {
	interface Post {
		title: string;
		path: string;
		description: string;
		image: string;
		published: string;
		readTime: number;
		likes: number;
		category: string;
		tags: string[];
	}
	namespace App {}
}

declare module 'mdsvex' {
	export interface MdsvexOptions {
		extensions?: string[];
		layout?: string;
		frontmatter?: {
			type?: 'yaml' | 'toml';
			marker?: string;
		};
		smartypants?: boolean;
		remarkPlugins?: any[];
		rehypePlugins?: any[];
	}

	export function compile(
		content: string,
		options?: MdsvexOptions
	): Promise<{
		code: string;
		data: {
			fm: Record<string, unknown>;
		};
	}>;
}

export {};
